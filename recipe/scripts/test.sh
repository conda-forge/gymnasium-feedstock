#!/usr/bin/env bash

set -euxo pipefail

env

TESTS_TO_SKIP="_not_a_real_test"
# These test requires mujoco_py, see https://github.com/conda-forge/gymnasium-feedstock/pull/36#issuecomment-2124082918
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_x_position"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_y_position"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_x_velocity"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_y_velocity"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_xy_velocity_xpos"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_verify_info_xy_velocity_com"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_set_state"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_distance_from_origin_info"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_model_sensors"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_reset_noise_scale"
# These tests do not run on CI due to missing window system, see https://github.com/conda-forge/gymnasium-feedstock/pull/36#issuecomment-2124183361
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_max_geom_attribute[10-human]"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_max_geom_attribute[100-human]"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_max_geom_attribute[1000-human]"
TESTS_TO_SKIP="$TESTS_TO_SKIP or test_max_geom_attribute[10000-human]"
if [[ "$(uname -s)" == Darwin* ]]; then
    # the following pygame tests are skipped [according to selector], because there is no rendering support during the CI build
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_human_rendering"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_keyboard_irrelevant_keydown_event"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_keyboard_keyup_event"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_keyboard_quit_event"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_keyboard_relevant_keydown_event"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_no_error_warnings[env0]"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_no_error_warnings[env1]"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_play_loop_real_env"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_play_relevant_keys"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_pygame_quit_event"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_video_size_no_zoom"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_video_size_zoom"
    # The following tests fail as for mujoco the osmesa rendering backend is only supported on Linux
    # See https://github.com/conda-forge/gymnasium-feedstock/pull/41#issuecomment-2428691450
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_offscreen_viewer_custom_dimensions"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_max_geom_attribute"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_camera_id"
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_num_envs_screen_size"
fi


if [[ "$(uname -m)" == aarch64 ]]; then
    # See https://github.com/conda-forge/gymnasium-feedstock/pull/32#issuecomment-2031810613
    TESTS_TO_SKIP="$TESTS_TO_SKIP or test_render_modes"
    # Workaround for https://github.com/conda-forge/gymnasium-feedstock/pull/41#issuecomment-2429842932
    # Remove once test run under a glibc 2.32 distro
    export LD_PRELOAD=libgomp.so.1
fi
# atari test are skipped as we do not have atari ROMs in the CI
# See https://github.com/conda-forge/gymnasium-feedstock/pull/41#issuecomment-2404215826
rm tests/wrappers/test_atari_preprocessing.py
# need to specify opengl driver on linux to enable offscreen rendering in MuJoCo
export MUJOCO_GL="osmesa"
# Ensure that pygame tests pass on unix,
# see https://github.com/conda-forge/gymnasium-feedstock/pull/36#issuecomment-2124699477
export SDL_VIDEODRIVER="dummy"
pytest -v tests/ -k "not ($TESTS_TO_SKIP)"
