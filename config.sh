#!/bin/bash

function get_property(){
    FILE_NAME=$1
    KEY=$2
    echo `cat $FILE_NAME | grep $KEY | cut -d "=" -f2`
}

function add_log_file(){
    local API_UN="$1"
    local API_PW="$2"
    local ENDPOINT_URL="$3"
    local PROCESS_ID="$4"
    local LOGLEVEL="$5"
    local LOGFILE="$6"

    RESPONSE=$(curl --user "$API_UN:$API_PW" -X "POST" --header "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@"$LOGFILE" "$ENDPOINT_URL/api/v3/integrations/runs/logs/$PROCESS_ID/logs/file?log_level=$LOGLEVEL")
    echo "$RESPONSE"
}

export ENDPOINT_URL=$(get_property $SCRIPT_DIR"/properties" "URL")
export DL_PATH="$(realpath "$SCRIPT_DIR/tmp")"
export SDEL="|"
export TDEL=","
export MAX_IMPORT_CSV_CELLS="400000"
export DAT_PART_PREFIX="part_"
export CSV_PART_PREFIX="part_"
export WGET_DOWNLOAD_RETRIES="30"
export IMPORT_CURL_RETRIES="20"
export WAIT_SEC_BEFORE_NEXT_RETRY="300"
export DAT_CELLS_PER_FILE="5000000"

typeset -A IMP_IDS
IMP_IDS=(
    # Registration
    [RA-REG]="10017466"
    [CO-Tower-REG]="10017468"
    [CO-Array-REG]="10017471"
    [EN-REG]="10017526"
    [HS-REG]="10017527"
    [RE-REG]="10017529"
    [SC-REG]="10017528"
)

typeset -A IMP_ACTIONS
IMP_ACTIONS=(
    # Registration
    [RA-REG]="INSERT_UPDATE"
    [CO-Tower-REG]="INSERT_UPDATE"
    [CO-Array-REG]="INSERT_UPDATE"
    [EN-REG]="INSERT_UPDATE"
    [HS-REG]="INSERT"
    [RE-REG]="INSERT_UPDATE"
    [SC-REG]="INSERT_UPDATE"
)

typeset -A IMP_ORDER
IMP_ORDER=(
    # Registration
    [RA-REG]="1"
    [CO-Tower-REG]="2"
    [CO-Array-REG]="3"
    [EN-REG]="4"
    [HS-REG]="5"
    [RE-REG]="6"
    [SC-REG]="7"
)

typeset -A DAT_COL_COUNTS
DAT_COL_COUNTS=(
    [RA]=42
    [EN]=25
    [CO]=18
    [RE]=9
    [SC]=8
    [HS]=7
)

case "$(date +%u)" in
	1)	DAY_NAME="sun"
		;;
	2)	DAY_NAME="mon"
		;;
	3)	DAY_NAME="tue"
		;;
	4)	DAY_NAME="wed"
		;;
	5)	DAY_NAME="thu"
		;;
	6)	DAY_NAME="fri"
		;;
	7)	DAY_NAME="sat"
		;;
esac

typeset -A DL_SETS
DL_SETS=(
    [full]="full_r"
    [daily]="daily_r"
    [daily_sun]="daily_r_sun"
    [daily_mon]="daily_r_mon"
    [daily_tue]="daily_r_tue"
    [daily_wed]="daily_r_wed"
    [daily_thu]="daily_r_thu"
    [daily_fri]="daily_r_fri"
    [daily_sat]="daily_r_sat"
)

typeset -A DL_URLS
DL_URLS=(
    [full_r]="https://wireless.fcc.gov/uls/data/complete/r_tower.zip"
    [daily_r]="https://wireless.fcc.gov/uls/data/daily/r_tow_$DAY_NAME.zip"
    [daily_r_sun]="https://wireless.fcc.gov/uls/data/daily/r_tow_sun.zip"
    [daily_r_mon]="https://wireless.fcc.gov/uls/data/daily/r_tow_mon.zip"
    [daily_r_tue]="https://wireless.fcc.gov/uls/data/daily/r_tow_tue.zip"
    [daily_r_wed]="https://wireless.fcc.gov/uls/data/daily/r_tow_wed.zip"
    [daily_r_thu]="https://wireless.fcc.gov/uls/data/daily/r_tow_thu.zip"
    [daily_r_fri]="https://wireless.fcc.gov/uls/data/daily/r_tow_fri.zip"
    [daily_r_sat]="https://wireless.fcc.gov/uls/data/daily/r_tow_sat.zip"
)
