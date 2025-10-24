#!/usr/bin/dumb-init /bin/bash
# Script to download audio and video shows from BBC iPlayer using get_iplayer

function process_shows() {

  local show_name_comma_separated="${1}"
  shift
  local show_name_format="${1}"
  shift
  local show_type="${1}"
  shift
  local show_name_strip

  local show_name_array
  IFS=',' read -ra show_name_array <<< "${show_name_comma_separated}"

  local show_name
  for show_name in "${show_name_array[@]}"; do

    show_name_strip=$(echo "${show_name}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')
    echo "[info] Downloading ${show_type} for show '${show_name}'..."
    get_iplayer "${show_name_strip}" "${show_name_format}" "${show_type}"

  done

}

function get_iplayer() {

  local show_name="${1}"
  shift
  local show_name_format="${1}"
  shift
  local show_type="${1}"
  shift

  # Set common commands
  local common_start_array=("${GET_IPLAYER_FILEPATH}" "--profile-dir" "/config" "--atomicparsley" "${ATOMIC_PARSELY_FILEPATH}")
  local common_end_array=("--file-prefix=<nameshort> - <senum> - <episodeshort>" "--subdir" "--subdir-format=<nameshort>" "--output" "${INCOMPLETE_PATH}")

  # Initialize the command array
  local cmd=("${common_start_array[@]}")

  if [[ "${show_type}" == "video" ]]; then

    cmd+=("--tv-quality=fhd,hd,sd,web,mobile")

    if [[ "${show_name_format}" == "name" ]]; then
      cmd+=("--get" "${show_name}")
    else
      cmd+=("--pid=${show_name}" "--pid-recursive")
    fi

  elif [[ "${show_type}" == "audio" ]]; then

    cmd+=("--type=radio")

    if [[ "${show_name_format}" == "name" ]]; then
      cmd+=("--get" "${show_name}")
    else
      cmd+=("--pid=${show_name}" "--pid-recursive")
    fi

  else
    echo "[error] Invalid show type '${show_type}' specified, skipping download for show '${show_name}'."
    return 1
  fi

  # Append the common end options
  cmd+=("${common_end_array[@]}")

  # Print the constructed command for debugging
  echo "[debug] Running command: ${cmd[*]}"

  # Execute the command
  "${cmd[@]}"

  echo "[info] Download complete for show '${show_name}'."

  move_completed "${show_name}"

}

function move_completed() {

  local show_name="${1}"
  shift

  if [[ -n $(find "${INCOMPLETE_PATH}" -name '*.m??') ]]; then

    echo "[info] Copying completed files for show '${show_name}' to completed folder '${COMPLETED_PATH}'..."

    if cp -rf "${INCOMPLETE_PATH}"* "${COMPLETED_PATH}"; then

      echo "[info] Copy successful, deleting incomplete files..."

      # delete only subfolders and files 1 level deep in the incomplete folder
      find "${INCOMPLETE_PATH}" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

      echo "[info] All incomplete files have been deleted."

    else

      echo "[error] Copy failed, skipping deletion of show folders in incomplete folder..."

    fi

  fi

}

function pre_check() {

  local ffmpeg_path='/usr/sbin/ffmpeg'

  # set legacy env vars to new format
  if [[ -n "${SHOWS}" ]]; then
    VIDEO_SHOWS_NAME="${SHOWS}"
  fi

  # set legacy env vars to new format
  if [[ -n "${SHOWS_PID}" ]]; then
    VIDEO_SHOWS_PID="${SHOWS_PID}"
  fi

  # if none of the env vars defined then exit
  if [[ -z "${VIDEO_SHOWS_NAME}" && -z "${VIDEO_SHOWS_PID}" && -z "${AUDIO_SHOWS_NAME}" && -z "${AUDIO_SHOWS_PID}" ]]; then

    echo "[crit] Video/Audio show name or PID is not defined."
    echo "[crit] Please specify the show name via env var 'VIDEO_SHOWS_NAME' and/or 'AUDIO_SHOWS_NAME'."
    echo "[crit] Alternatively, specify the show PID via env var 'VIDEO_SHOWS_PID' and/or 'AUDIO_SHOWS_PID'."
    echo "[crit] Exiting script..."
    exit 1

  fi

  # create globals for paths
  ATOMIC_PARSELY_FILEPATH='/usr/sbin/atomicparsley'
  GET_IPLAYER_FILEPATH='/usr/bin/get_iplayer'

  # check all required tools are available
  if [[ ! -f "${ffmpeg_path}" ]]; then
    echo "[error] ffmpeg not found at '${ffmpeg_path}', exiting..."
    exit 1
  fi
  if [[ ! -f "${ATOMIC_PARSELY_FILEPATH}" ]]; then
    echo "[error] atomicparsley not found at '${ATOMIC_PARSELY_FILEPATH}', exiting..."
    exit 1
  fi
  if [[ ! -f "${GET_IPLAYER_FILEPATH}" ]]; then
    echo "[error] get_iplayer not found at '${GET_IPLAYER_FILEPATH}', exiting..."
    exit 1
  fi

  # make folder for incomplete downloads
  mkdir -p "${INCOMPLETE_PATH}" || { echo "[error] Failed to create incomplete folder '${INCOMPLETE_PATH}', exiting..."; exit 1; }

  # make folder for completed downloads
  mkdir -p "${COMPLETED_PATH}" || { echo "[error] Failed to create completed folder '${COMPLETED_PATH}', exiting..."; exit 1; }

  # set locations for ffmpeg and atomicparsley
  "${GET_IPLAYER_FILEPATH}" --profile-dir /config --prefs-add --ffmpeg="${ffmpeg_path}" --atomicparsley="${ATOMIC_PARSELY_FILEPATH}"

}

function main() {

  pre_check

  while true; do

    if [[ -n "${VIDEO_SHOWS_NAME}" ]]; then
      process_shows "${VIDEO_SHOWS_NAME}" "name" "video"
    fi
    if [[ -n "${VIDEO_SHOWS_PID}" ]]; then
      process_shows "${VIDEO_SHOWS_PID}" "pid" "video"
    fi
    if [[ -n "${AUDIO_SHOWS_NAME}" ]]; then
      process_shows "${AUDIO_SHOWS_NAME}" "name" "audio"
    fi
    if [[ -n "${AUDIO_SHOWS_PID}" ]]; then
      process_shows "${AUDIO_SHOWS_PID}" "pid" "audio"
    fi

    # if env variable SCHEDULE not defined then use default
    if [[ -z "${SCHEDULE}" ]]; then
      echo "[info] Env var SCHEDULE not defined, sleeping for 12 hours..."
      sleep 12h
    else
      echo "[info] Env var SCHEDULE defined, sleeping for ${SCHEDULE}..."
      sleep "${SCHEDULE}"
    fi

  done

}

# run function to start processing
main
