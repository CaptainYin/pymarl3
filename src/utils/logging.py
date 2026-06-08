from collections import defaultdict
import logging
import numpy as np
import torch as th


class Logger:
    def __init__(self, console_logger):
        self.console_logger = console_logger

        self.use_tb = False
        self.use_sacred = False
        self.use_hdf = False
        self.use_wandb = False
        self.wandb = None
        self._wandb_returns_by_step = {}
        self._wandb_lengths_by_step = {}
        self._wandb_eval_returns_by_step = {}
        self._wandb_eval_lengths_by_step = {}

        self.stats = defaultdict(lambda: [])

    def setup_tb(self, directory_name):
        # Import here so it doesn't have to be installed if you don't use it
        from tensorboard_logger import configure, log_value
        configure(directory_name)
        self.tb_logger = log_value
        self.use_tb = True

    def setup_sacred(self, sacred_run_dict):
        self.sacred_info = sacred_run_dict.info
        self.use_sacred = True

    def setup_wandb(self, project, name, mode, config, group=None):
        import wandb

        self.wandb = wandb
        wandb.init(project=project, name=name, mode=mode, group=group, config=config, reinit=True)
        wandb.define_metric("steps")
        wandb.define_metric("*", step_metric="steps")
        self.use_wandb = True

    def log_stat(self, key, value, t, to_sacred=True):
        self.stats[key].append((t, value))

        if self.use_tb:
            self.tb_logger(key, value, t)

        if self.use_sacred and to_sacred:
            if key in self.sacred_info:
                self.sacred_info["{}_T".format(key)].append(t)
                self.sacred_info[key].append(value)
            else:
                self.sacred_info["{}_T".format(key)] = [t]
                self.sacred_info[key] = [value]

        if self.use_wandb:
            self.wandb.log(self._wandb_payload(key, value, t), step=t)

    def close(self):
        if self.use_wandb and self.wandb.run is not None:
            self.wandb.finish()

    def _wandb_payload(self, key, value, t):
        value = self._to_wandb_value(value)
        payload = {"steps": t, key: value}

        aliases = {
            "return_mean": ["returns"],
            "test_return_mean": ["eval_returns"],
            "ep_length_mean": ["epi_length", "average_episode_length"],
            "test_ep_length_mean": ["eval_avg_epi_len", "eval_average_episode_length"],
            "battle_won_mean": ["win", "incre_win_rate"],
            "test_battle_won_mean": ["eval_win_rate", "test_win_rate"],
        }
        for alias in aliases.get(key, []):
            payload[alias] = value
        self._add_rew_per_step_aliases(payload, key, value, t)
        return payload

    def _add_rew_per_step_aliases(self, payload, key, value, t):
        step = int(t)
        if key == "return_mean":
            self._wandb_returns_by_step[step] = value
        elif key == "ep_length_mean":
            self._wandb_lengths_by_step[step] = value
        elif key == "test_return_mean":
            self._wandb_eval_returns_by_step[step] = value
        elif key == "test_ep_length_mean":
            self._wandb_eval_lengths_by_step[step] = value

        if key in ("return_mean", "ep_length_mean"):
            returns = self._wandb_returns_by_step.get(step)
            length = self._wandb_lengths_by_step.get(step)
            if returns is not None and length:
                payload["rew_per_step"] = returns / max(length, 1.0)
        elif key in ("test_return_mean", "test_ep_length_mean"):
            returns = self._wandb_eval_returns_by_step.get(step)
            length = self._wandb_eval_lengths_by_step.get(step)
            if returns is not None and length:
                payload["eval_rew_per_step"] = returns / max(length, 1.0)

    @staticmethod
    def _to_wandb_value(value):
        if isinstance(value, np.generic):
            return value.item()
        if isinstance(value, th.Tensor):
            if value.numel() == 1:
                return value.item()
            return value.detach().cpu().numpy()
        return value

    def print_recent_stats(self):
        log_str = "Recent Stats | t_env: {:>10} | Episode: {:>8}\n".format(*self.stats["episode"][-1])
        i = 0
        for (k, v) in sorted(self.stats.items()):
            if k == "episode":
                continue
            i += 1
            window = 5 if k != "epsilon" else 1
            item = "{:.4f}".format(th.mean(th.tensor([float(x[1]) for x in self.stats[k][-window:]])))
            log_str += "{:<25}{:>8}".format(k + ":", item)
            log_str += "\n" if i % 4 == 0 else "\t"
        self.console_logger.info(log_str)
        # Reset stats to avoid accumulating logs in memory
        self.stats = defaultdict(lambda: [])


# set up a custom logger
def get_logger():
    logger = logging.getLogger()
    logger.handlers = []
    ch = logging.StreamHandler()
    formatter = logging.Formatter('[%(levelname)s %(asctime)s] %(name)s %(message)s', '%H:%M:%S')
    ch.setFormatter(formatter)
    logger.addHandler(ch)
    logger.setLevel('DEBUG')

    return logger
