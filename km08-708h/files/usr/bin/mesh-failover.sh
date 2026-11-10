#!/bin/sh
# Alameer Software - Ethernet -> 802.11s mesh failover
# Cable down  -> bridge the mesh interface into br-lan (traffic flows over the air)
# Cable up    -> take the mesh interface out of the bridge at once (no loop)

[ -f /etc/mesh-failover.conf ] && . /etc/mesh-failover.conf
BRIDGE="${BRIDGE:-br-lan}"
MESH_IF="${MESH_IF:-mesh0}"
INTERVAL="${INTERVAL:-1}"
DOWN_DELAY="${DOWN_DELAY:-5}"
GATE_MODE="${GATE_MODE:-0}"
UPLINK_PORTS="${UPLINK_PORTS:-}"

log() { logger -t mesh-failover "$*"; }

wired_ports() {
	if [ -n "$UPLINK_PORTS" ]; then
		echo $UPLINK_PORTS
	else
		for p in $(ls /sys/class/net/$BRIDGE/brif 2>/dev/null); do
			case "$p" in wlan*|mesh*|phy*|ra*|apcli*) ;; *) echo "$p";; esac
		done
	fi
}

wired_up() {
	for p in $(wired_ports); do
		[ "$(cat /sys/class/net/$p/carrier 2>/dev/null)" = "1" ] && return 0
	done
	return 1
}

mesh_exists()   { [ -d "/sys/class/net/$MESH_IF" ]; }
mesh_attached() { [ -e "/sys/class/net/$BRIDGE/brif/$MESH_IF" ]; }

attach() {
	mesh_exists || return 1
	mesh_attached && return 0
	ip link set dev "$MESH_IF" up
	ip link set dev "$MESH_IF" master "$BRIDGE" && log "cable down: mesh $MESH_IF bridged into $BRIDGE"
}

detach() {
	mesh_attached || return 0
	ip link set dev "$MESH_IF" nomaster && log "cable up: mesh $MESH_IF removed from $BRIDGE"
}

[ "$GATE_MODE" = "1" ] && ip link set dev "$BRIDGE" type bridge stp_state 1 2>/dev/null

down=0
while :; do
	if [ "$GATE_MODE" = "1" ]; then
		attach
	elif wired_up; then
		down=0
		detach
	else
		down=$((down + INTERVAL))
		[ "$down" -ge "$DOWN_DELAY" ] && attach
	fi
	sleep "$INTERVAL"
done
