set TESTS_TO_SKIP=_not_a_real_test
REM These test requires mujoco_py, see https://github.com/conda-forge/gymnasium-feedstock/pull/36#issuecomment-2124082918
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_x_position
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_y_position
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_x_velocity
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_y_velocity
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_xy_velocity_xpos
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_verify_info_xy_velocity_com
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_set_state
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_distance_from_origin_info
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_model_sensors
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_reset_noise_scale
REM These tests do not run on CI due to missing window system, see https://github.com/conda-forge/gymnasium-feedstock/pull/36#issuecomment-2124183361
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_max_geom_attribute[10-human]
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_max_geom_attribute[100-human]
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_max_geom_attribute[1000-human]
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_max_geom_attribute[10000-human]

REM The following tests fail as for mujoco the osmesa rendering backend is only supported on Linux
REM See https://github.com/conda-forge/gymnasium-feedstock/pull/41#issuecomment-2428691450
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_offscreen_viewer_custom_dimensions
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_max_geom_attribute
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_camera_id
set TESTS_TO_SKIP=%TESTS_TO_SKIP% or test_num_envs_screen_size

REM atari test are skipped as we do not have atari ROMs in the CI
REM See https://github.com/conda-forge/gymnasium-feedstock/pull/41#issuecomment-2404215826
del tests\\wrappers\\test_atari_preprocessing.py

pytest -v tests/ -k "not (%TESTS_TO_SKIP%)"
