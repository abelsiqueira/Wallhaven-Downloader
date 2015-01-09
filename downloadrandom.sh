base="http://alpha.wallhaven.cc/"
options="search?page=1&categories=111&purity=111&resolutions=1920x1080&sorting=random"
if [ -z "$1" ]; then
  url="${base}${options}"
else
  url="${base}${options}&q=$*"
  echo $url
fi
wget -q --keep-session-cookies --load-cookies=cookies.txt \
  --referer=alpha.wallhaven.cc -O page "$url"

imgurl=$(cat page |\
  grep -o '<a .* href="http://alpha.wallhaven.cc/wallpaper/[0-9]*"' |\
  head -n 1 | sed 's/.\{25\}//')

img=$(echo $imgurl | sed 's/.\{1\}$//')
number=$(echo $img | sed 's/.\{36\}//')
wget -q --keep-session-cookies --load-cookies=cookies.txt \
  --referer=alpha.wallhaven.cc $img
name=$(egrep -o 'wallpaper.*(png|jpg|gif)' $number)
ext=${name##*.}
wget -q --keep-session-cookies --load-cookies=cookies.txt \
  --referer=http://alpha.wallhaven.cc/wallpaper/$number $name -O wallpaper.$ext
mv wallpaper.$ext $HOME/images/
rm -f $number
rm -f page
