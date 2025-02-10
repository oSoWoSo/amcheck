#!/bin/sh

# Download and extract AM-main
wget -q https://github.com/ivan-hc/AM/archive/refs/heads/main.zip && unzip -qq ./main.zip && cd AM-main/programs/x86_64 || exit 1

# Detect AppImages hosted on github
for f in *; do
	if grep -q "api.github.com" "$f" 2>/dev/null; then
		if grep -qe "appimage-extract\|mage\$\|tmp/\*mage" "$f" 1>/dev/null; then
			if grep -q "^APP=" "$f" 2>/dev/null; then
				APP=$(eval echo "$(grep -i '^APP=' "$f" | head -1 | sed 's/APP=//g')")
				echo "APP=\"$APP\""
			fi	
			if grep -q "^REPO=" "$f" 2>/dev/null; then
				REPO=$(eval echo "$(grep -i '^REPO=' "$f" | head -1 | sed 's/REPO=//g')")
				echo "REPO=\"$REPO\""
			fi	
			if grep -q "^SITE=" "$f" 2>/dev/null; then
				SITE=$(eval echo "$(grep -i '^SITE=' "$f" | head -1 | sed 's/SITE=//g')")
				echo "SITE=\"$SITE\""
			fi	
			if grep -q "^d=" "$f" 2>/dev/null; then
				d=$(eval echo "$(grep -i '^d=' "$f" | head -1 | sed 's/d=//g')")
				echo "d=\"$d\""
			fi	
			if grep -q "^dl=" "$f" 2>/dev/null; then
				dl=$(eval echo "$(grep -i '^dl=' "$f" | head -1 | sed 's/dl=//g')")
				echo "dl=\"$dl\""
			fi	
			if grep -q "^rel=" "$f" 2>/dev/null; then
				rel=$(eval echo "$(grep -i '^rel=' "$f" | head -1 | sed 's/rel=//g')")
				echo "rel=\"$rel\""
			fi	
			if grep -q "^tag=" "$f" 2>/dev/null; then
				tag=$(eval echo "$(grep -i '^tag=' "$f" | head -1 | sed 's/tag=//g')")
				echo "tag=\"$tag\""
			fi	
			if grep -q "^v=" "$f" 2>/dev/null; then
				v=$(eval echo "$(grep -i '^v=' "$f" | head -1 | sed 's/v=//g')")
				echo "v=\"$v\""
			fi	
			if grep -q "^ver=" "$f" 2>/dev/null; then
				ver=$(eval echo "$(grep -i '^ver=' "$f" | head -1 | sed 's/ver=//g')")
				echo "ver=\"$ver\""
			fi	
			if grep -q "^version=" "$f" 2>/dev/null; then
				version=$(eval echo "$(grep -i '^version=' "$f" | head -1 | sed 's/version=//g')")
				if [ -z "$version" ]; then
					sed -i 's/curl -Ls/torsocks curl -Ls/g' "$f"
					version=$(eval echo "$(grep -i '^version=' "$f" | head -1 | sed 's/version=//g')")
					if [ -z "$version" ]; then
						sudo systemctl restart tor.service || systemctl restart tor.service
						wait
						version=$(eval echo "$(grep -i '^version=' "$f" | head -1 | sed 's/version=//g')")
					fi
				fi
				[ -n "$version" ] && echo "version=\"$version\"" || exit 0
			fi
			unset APP 2>/dev/null
			unset REPO 2>/dev/null
			unset SITE 2>/dev/null
			unset version 2>/dev/null
			echo '-----------------------------------------------------------------'
		fi
	fi
done
