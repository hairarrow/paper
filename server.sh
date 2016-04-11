#!/bin/bash
function end () {

  BS_PID=$(ps aux | grep '[b]rowser-sync' | awk '{print $2}')
  SASS_PID=$(ps aux | grep '[s]ass' | awk '{print $2}')
  POST_PID=$(ps aux | grep '[p]ostcss' | awk '{print $2}')

  echo "Clearing CSS Cache and closing ending processes"

  rm -rf hot.css

  if [ "$BS_PID" ]; then {
    echo "Ending browser-sync process"
    kill -9 $BS_PID
  };fi

  if [ "$SASS_PID" ]; then {
    echo "Ending sass process"
    kill -9 $SASS_PID
  };fi

  if [ "$POST_PID" ]; then {
    echo "Ending postcss process"
    kill -9 $POST_PID
  };fi
}

if [ "$1" == "kill" ]; then {

  end

} elif [ "$1" == "gh-init" ]; then {

  echo "CREATING GH PAGES"
  #TODO

} elif [ "$1" == "deploy" ]; then {

  echo "DEPLOYING"
  # TODO

} else {

  echo "

********************************************************
*                                                      *
*     Starting browser-sync, sass and autoprefixer     *
*                                                      *
*     Serving and watching files from: ./              *
*     run '. server.sh kill' to end these process      *
*                                                      *
********************************************************

  "

  touch hot.css
  sass --sourcemap=none --no-cache --quiet --watch styles.sass:hot.css &
  postcss --use autoprefixer --output styles.css hot.css --watch &
  browser-sync start --server --logLevel=silent --no-notify --files "*.html, *.js, *.css" &
  sleep 1
  touch styles.sass

};fi
