'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	load: function () {
		return uci.load(['network', 'wireless']);
	},

	render: function () {
		var nm = new form.Map('network', _('Quick Programming'),
			_('Choose the right programming mode and press Save & Apply - اختر وضع البرمجة المناسبة واضغط على حفظ')),
		    wm = new form.Map('wireless'),
		    s, o;

		/* ---------------- LAN ---------------- */
		s = nm.section(form.NamedSection, 'lan', 'interface', _('LAN'));

		o = s.option(form.Value, 'ipaddr', _('IPv4 address'));
		o.datatype = 'ip4addr("nomask")';
		o.rmempty = false;

		o = s.option(form.Value, 'netmask', _('IPv4 netmask'));
		o.datatype = 'ip4addr("nomask")';
		o.value('255.255.255.0');
		o.value('255.255.0.0');
		o.value('255.0.0.0');
		o.value('255.255.255.128');
		o.rmempty = false;

		o = s.option(form.Value, 'gateway', _('IPv4 gateway'));
		o.datatype = 'ip4addr("nomask")';
		o.optional = true;

		/* ---------------- Radios ---------------- */
		uci.sections('wireless', 'wifi-device').forEach(function (r) {
			var rid = r['.name'];
			var band = r.band;
			if (!band) {
				if (r.hwmode == '11g') band = '2g';
				else if (r.hwmode == '11a') band = '5g';
				else band = (+r.channel > 0 && +r.channel <= 14) ? '2g' : '5g';
			}
			var is2g = (band == '2g');
			var title = is2g ? _('Wireless 2.4GHz') : _('Wireless 5GHz');

			s = wm.section(form.NamedSection, rid, 'wifi-device', title + ' - ' + _('Radio'));

			o = s.option(form.Value, 'channel', _('Channel'));
			o.value('auto', _('auto'));
			if (is2g) for (var c = 1; c <= 13; c++) o.value(c);
			else [36, 40, 44, 48, 52, 56, 60, 64, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165].forEach(function (c) { o.value(c); });

			o = s.option(form.ListValue, 'htmode', _('Width / Mode'));
			if (is2g) {
				o.value('HT20', 'N - 20 MHz');
				o.value('HT40', 'N - 40 MHz');
			} else {
				o.value('VHT20', 'AC - 20 MHz');
				o.value('VHT40', 'AC - 40 MHz');
				o.value('VHT80', 'AC - 80 MHz');
			}

			o = s.option(form.Value, 'txpower', _('Maximum transmit power (dBm)'));
			o.datatype = 'range(1,30)';
			o.optional = true;

			var ifc = uci.sections('wireless', 'wifi-iface').filter(function (i) { return i.device == rid; })[0];
			if (!ifc) return;
			var sid = ifc['.name'];

			s = wm.section(form.NamedSection, sid, 'wifi-iface', title + ' - ' + _('Network'));

			o = s.option(form.ListValue, 'alameer_type', _('Type'));
			o.value('ap', 'Access Point - برمجة أكسس');
			o.value('ap-wds', 'Access Point (WDS) - برمجة أكسس WDS');
			o.value('mesh', 'MESH - برمجة أكسس MESH');
			o.cfgvalue = function (section_id) {
				if (uci.get('wireless', section_id, 'mode') == 'mesh') return 'mesh';
				return uci.get('wireless', section_id, 'wds') == '1' ? 'ap-wds' : 'ap';
			};
			o.write = function (section_id, value) {
				if (value == 'mesh') {
					uci.set('wireless', section_id, 'mode', 'mesh');
					uci.unset('wireless', section_id, 'wds');
				} else {
					uci.set('wireless', section_id, 'mode', 'ap');
					uci.unset('wireless', section_id, 'mesh_id');
					if (value == 'ap-wds') uci.set('wireless', section_id, 'wds', '1');
					else uci.unset('wireless', section_id, 'wds');
				}
			};
			o.remove = function () {};

			o = s.option(form.Value, 'ssid', _('ESSID'));
			o.depends('alameer_type', 'ap');
			o.depends('alameer_type', 'ap-wds');
			o.datatype = 'maxlength(32)';
			o.rmempty = false;

			o = s.option(form.Value, 'mesh_id', _('Mesh ID'));
			o.depends('alameer_type', 'mesh');
			o.placeholder = 'AL-AMEER-MESH';
			o.rmempty = false;

			o = s.option(form.ListValue, 'network', _('Network (VLAN mapping)'));
			uci.sections('network', 'interface').forEach(function (n) {
				if (n['.name'] != 'loopback') o.value(n['.name']);
			});
			o.default = 'lan';

			o = s.option(form.Flag, 'isolate', _('Isolate Clients'));
			o.depends('alameer_type', 'ap');
			o.depends('alameer_type', 'ap-wds');

			o = s.option(form.ListValue, 'encryption', _('Security'));
			o.value('none', _('No Encryption'));
			o.value('psk2', 'WPA2-PSK');
			o.value('sae', 'WPA3-SAE');
			o.default = 'none';

			o = s.option(form.Value, 'key', _('Wifi password'));
			o.password = true;
			o.datatype = 'wpakey';
			o.depends('encryption', 'psk2');
			o.depends('encryption', 'sae');
			o.rmempty = false;
		});

		return Promise.all([nm.render(), wm.render()]).then(function (nodes) {
			return E([
				E('div', { 'style': 'text-align:center;margin-bottom:1em' }, [
					E('img', { 'src': '/luci-static/alameer/logo.png', 'style': 'max-width:150px;height:auto' })
				]),
				nodes[0],
				nodes[1]
			]);
		});
	}
});
