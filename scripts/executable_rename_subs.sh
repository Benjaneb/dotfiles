#!/bin/zsh

animes=(*.mkv)
subs=(subs/*)
sub_ending=${subs[1]##*.}

for i in {1..${#animes}}; do
	mv $subs[i] "subs/${animes[i]%.mkv}.$sub_ending"
done
