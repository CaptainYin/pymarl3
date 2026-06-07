#!/bin/bash
# Install SC2 and add the custom maps

# Clone the source code.
#git clone git@github.com:tjuHaoXiaotian/pymarl3.git
export PYMARL3_CODE_DIR=$(pwd)

# 1. Install StarCraftII
echo 'Install StarCraftII...'
cd "$HOME"
export SC2PATH="$HOME/StarCraftII"
echo 'SC2PATH is set to '$SC2PATH
if [ ! -d $SC2PATH ]; then
        echo 'StarCraftII is not installed. Installing now ...';
        wget http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip
        unzip -P iagreetotheeula SC2.4.10.zip
else
        echo 'StarCraftII is already installed.'
fi

# 2. Install the custom maps

# Copy the maps to the target dir.
echo 'Install SMACV1 and SMACV2 maps...'
MAP_DIR="$SC2PATH/Maps/"
if [ ! -d "$MAP_DIR/SMAC_Maps" ]; then
    echo 'MAP_DIR is set to '$MAP_DIR
    if [ ! -d $MAP_DIR ]; then
            mkdir -p $MAP_DIR
    fi
    cp -r "$PYMARL3_CODE_DIR/src/envs/smac_v2/official/maps/SMAC_Maps" $MAP_DIR
else
    echo 'SMACV1 and SMACV2 maps are already installed.'
fi
echo 'StarCraft II and SMAC maps are installed.'



# For SMAC, take the hpn_qmix, qmix, hpn_qplex and qplex over all hard and super-hard scenarios for example.

# 5m_vs_6m
CUDA_VISIBLE_DEVICES="0" python3 src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=5m_vs_6m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python3 src/main.py --config=qmix --env-config=sc2 with env_args.map_name=5m_vs_6m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python3 src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=5m_vs_6m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python3 src/main.py --config=qplex --env-config=sc2 with env_args.map_name=5m_vs_6m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# 3s5z_vs_3s6z
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=3s5z_vs_3s6z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=4 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=3s5z_vs_3s6z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=4 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=3s5z_vs_3s6z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=4 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=3s5z_vs_3s6z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=4 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# 6h_vs_8z
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=6h_vs_8z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=500000 batch_size=128 td_lambda=0.3 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=6h_vs_8z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=500000 batch_size=128 td_lambda=0.3 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=6h_vs_8z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=500000 batch_size=128 td_lambda=0.3 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=6h_vs_8z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=500000 batch_size=128 td_lambda=0.3 hpn_head_num=2

# 8m_vs_9m
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=8m_vs_9m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=8m_vs_9m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=8m_vs_9m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=8m_vs_9m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# 3s_vs_5z
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=3s_vs_5z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=3s_vs_5z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=3s_vs_5z obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 hpn_head_num=2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=3s_vs_5z obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 hpn_head_num=2

# corridor
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=corridor obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=corridor obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=corridor obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=corridor obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# MMM2
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=MMM2 obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=MMM2 obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=MMM2 obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=MMM2 obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# 27m_vs_30m
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=27m_vs_30m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=27m_vs_30m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=27m_vs_30m obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=27m_vs_30m obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# 2c_vs_64zg
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=2c_vs_64zg obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=2c_vs_64zg obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=2c_vs_64zg obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=2c_vs_64zg obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6

# bane_vs_bane
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qmix --env-config=sc2 with env_args.map_name=bane_vs_bane obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qmix --env-config=sc2 with env_args.map_name=bane_vs_bane obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_qplex --env-config=sc2 with env_args.map_name=bane_vs_bane obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=qplex --env-config=sc2 with env_args.map_name=bane_vs_bane obs_agent_id=True obs_last_action=True runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6



#%%%%%%%%%%%%%%%%%%% sc2_v2_terran %%%%%%%%%%%%%%%%%%%%%
CUDA_VISIBLE_DEVICES="1" python src/main.py --config=hpn_vdn --env-config=sc2_v2_terran with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn

CUDA_VISIBLE_DEVICES="0" python src/main.py --config=vdn --env-config=sc2_v2_terran with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn

#%%%%%%%%%%%%%%%%%%% sc2_v2_protoss %%%%%%%%%%%%%%%%%%%%%
CUDA_VISIBLE_DEVICES="0" python src/main.py --config=hpn_vdn --env-config=sc2_v2_protoss with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn

CUDA_VISIBLE_DEVICES="1" python src/main.py --config=vdn --env-config=sc2_v2_protoss with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn

#%%%%%%%%%%%%%%%%%%% sc2_v2_zerg %%%%%%%%%%%%%%%%%%%%%
CUDA_VISIBLE_DEVICES="1" python src/main.py --config=hpn_vdn --env-config=sc2_v2_zerg with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn

CUDA_VISIBLE_DEVICES="0" python src/main.py --config=vdn --env-config=sc2_v2_zerg with obs_agent_id=True obs_last_action=False runner=parallel batch_size_run=8 buffer_size=5000 t_max=10050000 epsilon_anneal_time=100000 batch_size=128 td_lambda=0.6 mixer=vdn
