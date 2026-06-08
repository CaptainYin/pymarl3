#!/usr/bin/env bash
set -euo pipefail

SEED="${SEED:-1}"
STEPS="${STEPS:-12000}"
MODE="${MODE:-offline}"
EVAL_INTERVAL="${EVAL_INTERVAL:-1000}"
LOG_INTERVAL="${LOG_INTERVAL:-1000}"
TEST_EPISODES="${TEST_EPISODES:-5}"
BATCH_SIZE_RUN="${BATCH_SIZE_RUN:-1}"
USE_CUDA="${USE_CUDA:-False}"
USE_TENSORBOARD="${USE_TENSORBOARD:-True}"
SAVE_MODEL="${SAVE_MODEL:-False}"
DRY_RUN="${DRY_RUN:-0}"
SKIP_SC2_CHECK="${SKIP_SC2_CHECK:-0}"
export SC2PATH="${SC2PATH:-/project/StarCraftII_4_10_2}"

if [ "$#" -gt 0 ]; then
  TASKS=("$@")
else
  TASKS=(terran_5_vs_5 protoss_5_vs_5 zerg_5_vs_5 zerg_10_vs_10 zerg_10_vs_11)
fi

read -r -a ALGOS <<< "${ALGOS:-qmix}"

task_env_config() {
  case "$1" in
    terran_5_vs_5)
      printf '%s\n' sc2_v2_terran
      ;;
    protoss_5_vs_5)
      printf '%s\n' sc2_v2_protoss
      ;;
    zerg_5_vs_5 | zerg_10_vs_10 | zerg_10_vs_11)
      printf '%s\n' sc2_v2_zerg
      ;;
    *)
      printf 'Unknown SMACv2 task: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

task_overrides() {
  case "$1" in
    zerg_10_vs_10)
      printf '%s\n' \
        "env_args.capability_config.n_units=10" \
        "env_args.capability_config.start_positions.n_enemies=10"
      ;;
    zerg_10_vs_11)
      printf '%s\n' \
        "env_args.capability_config.n_units=10" \
        "env_args.capability_config.start_positions.n_enemies=11"
      ;;
  esac
}

check_sc2_runtime() {
  if [ "$DRY_RUN" = "1" ] || [ "$SKIP_SC2_CHECK" = "1" ]; then
    return
  fi
  if [ ! -d "$SC2PATH/Versions" ]; then
    printf 'SMACv2 requires the StarCraft II runtime. Missing: %s/Versions\n' "$SC2PATH" >&2
    printf 'Set SC2PATH=/path/to/StarCraftII_4_10_2, or set SKIP_SC2_CHECK=1 to bypass this preflight.\n' >&2
    exit 2
  fi
}

check_sc2_runtime

cd /project/pymarl3

for ALGO in "${ALGOS[@]}"; do
  for TASK in "${TASKS[@]}"; do
    ENV_CONFIG="$(task_env_config "$TASK")"
    CMD=(
      python3 src/main.py
      "--config=${ALGO}"
      "--env-config=${ENV_CONFIG}"
      with
      "seed=${SEED}"
      "t_max=${STEPS}"
      "test_interval=${EVAL_INTERVAL}"
      "log_interval=${LOG_INTERVAL}"
      "runner_log_interval=${LOG_INTERVAL}"
      "learner_log_interval=${LOG_INTERVAL}"
      "test_nepisode=${TEST_EPISODES}"
      "batch_size_run=${BATCH_SIZE_RUN}"
      "use_cuda=${USE_CUDA}"
      "use_tensorboard=${USE_TENSORBOARD}"
      "save_model=${SAVE_MODEL}"
      "use_wandb=True"
      "wandb_project=SMACv2"
      "wandb_mode=${MODE}"
      "task_name=${TASK}"
      "wandb_name=${ALGO}_s${SEED}_${TASK}"
    )

    while IFS= read -r OVERRIDE; do
      [ -n "$OVERRIDE" ] && CMD+=("$OVERRIDE")
    done < <(task_overrides "$TASK")

    if [ "$DRY_RUN" = "1" ]; then
      printf '%q ' "${CMD[@]}"
      printf '\n'
    else
      "${CMD[@]}"
    fi
  done
done
