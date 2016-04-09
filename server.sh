#!/bin/bash
function end () {

  BS_PID=`ps aux | grep '[b]rowser-sync' | awk '{print $2}'`
  SASS_PID=`ps aux | grep '[s]ass' | awk '{print $2}'`
  POST_PID=`ps aux | grep '[p]ostcss' | awk '{print $2}'`

  echo "Clearing CSS Cache and closing ending processes"

  rm -rf hot.css
  rm -rf *.css.map

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

  exit 2
}

if [ "$1" == "kill" ]; then {

  end

} else {

  echo "

********************************************************
*                                                      *
*     Starting browser-sync, sass and autoprefixer     *
*                                                      *
*     Serving and watching files from: ./              *
*     Press Ctrl-C to end and close terminal           *
*                                                      *
********************************************************

  "

  browser-sync start --server --logLevel=silent --no-notify --files "*.html, *.js, *.css" &
  touch hot.css
  sass --sourcemap=none --no-cache --quiet --watch styles.sass:hot.css &
  postcss --use autoprefixer --output styles.css hot.css --watch &

};fi

touch styles.sass

trap "end" 2
