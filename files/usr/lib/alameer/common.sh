# Alameer Software - shared helpers (sourced by other scripts)

radios() { uci show wireless 2>/dev/null | sed -n 's/^wireless\.\([^.=]*\)=wifi-device$/\1/p'; }

get_band() {
	local r="$1" b hw ch
	b=$(uci -q get wireless.$r.band); [ -n "$b" ] && { echo "$b"; return; }
	hw=$(uci -q get wireless.$r.hwmode)
	case "$hw" in 11g) echo 2g; return;; 11a) echo 5g; return;; esac
	ch=$(uci -q get wireless.$r.channel)
	case "$ch" in ''|auto|*[!0-9]*) echo 5g;; *) [ "$ch" -le 14 ] && echo 2g || echo 5g;; esac
}

# list wifi-iface sections that belong to radio $1
ifaces_of() {
	uci show wireless 2>/dev/null | sed -n "s/^wireless\.\([^.=]*\)\.device='$1'$/\1/p" | while read -r i; do
		[ "$(uci -q get wireless.$i)" = "wifi-iface" ] && echo "$i"
	done
}

# list wifi-iface sections of band $1 (2g | 5g | both)
ifaces_of_band() {
	local want="$1" r
	for r in $(radios); do
		[ "$want" = "both" ] || [ "$(get_band $r)" = "$want" ] || continue
		ifaces_of "$r"
	done
}
