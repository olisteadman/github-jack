#!/bin/bash

REPO="$1"
TEMPLATE="$2"

MESSAGE='All work and no play makes Jack a dull boy.'
AUTHOR='Jack <jack@work.com>'
SHADE_MULTIPLIER=2

function day_count()
{
  local day_number="$1"
  local row=$(( $day_number % 7 + 1))
  local col=$(( $day_number / 7 + 1))
  local index=$(head "$TEMPLATE" -n $row | tail -n1 | head -c $col | tail -c1)

  echo $(( $index * $SHADE_MULTIPLIER))
}

function commit_year_work()
{
  local date_format='%Y-%m-%d'
  local start_date="$(date --date="-52 weeks next sunday" +$date_format)"
  local date count

  # 357 days is 51 weeks
  for (( c = 0; c < 357; c++ ))
  do
    date=$(date --date="$start_date +$c day" +$date_format)
    count=$(day_count $c)
    commit_day_work "$date" "$count"
  done
}

function random_time()
{
  local hours=$(( $RANDOM % 24 ))
  local minutes=$(( $RANDOM % 60 ))
  local seconds=$(( $RANDOM % 60 ))

  echo $hours:$minutes:$seconds
}

function commit_day_work()
{
  local date="$1"
  local count="$2"
  local time

  for ((i = 1; i <= $count; i++))
  do
    time=$(random_time)
    commit_a_work "$date" "$time"
  done
}

function commit_a_work()
{
  local date="$1"
  local time="$2"

  git \
  --git-dir="$REPO/.git" \
  --work-tree="$REPO" \
  commit \
  --allow-empty \
  --message "$MESSAGE" \
  --author "$AUTHOR" \
  --date "$date $time" \
  --quiet
}

commit_year_work
