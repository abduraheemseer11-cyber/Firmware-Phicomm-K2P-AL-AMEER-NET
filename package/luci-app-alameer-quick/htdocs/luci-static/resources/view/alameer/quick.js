'use strict';
'require view';
'require form';

return view.extend({
	render: function () {
		var m, s, o;

		m = new form.Map('alameer', _('البرمجة السريعة'),
			_('اختر وضع البرمجة المناسبة واضغط على حفظ'));

		s = m.section(form.NamedSection, 'main', 'quick');
		s.addremove = false;
		s.tab('quick', _('البرمجة السريعة'));
		s.tab('more', _('More Settings'));

		o = s.taboption('quick', form.ListValue, 'type', _('Type'));
		o.value('ap', 'برمجة أكسس Access Point');
		o.value('wds', 'برمجة أكسس WDS');
		o.value('mesh', 'برمجة أكسس MESH');
		o.default = 'ap';

		o = s.taboption('quick', form.Value, 'ipaddr', _('IPv4 address'));
		o.datatype = 'ip4addr("nomask")';
		o.placeholder = '192.168.1.20';

		o = s.taboption('quick', form.Value, 'netmask', _('IPv4 netmask'));
		o.datatype = 'ip4addr("nomask")';
		o.value('255.255.255.0');
		o.value('255.255.0.0');
		o.value('255.0.0.0');
		o.value('255.255.255.128');
		o.default = '255.255.255.0';

		o = s.taboption('quick', form.Value, 'ssid', _('اسم الشبكة'));
		o.placeholder = 'AL-AMEER-NET (0000)';

		o = s.taboption('quick', form.Flag, 'vlan', _('إضافة فيلان'));
		o.rmempty = false;

		o = s.taboption('quick', form.Value, 'vlan_id', _('VLAN ID'));
		o.datatype = 'range(1,4094)';
		o.depends('vlan', '1');

		o = s.taboption('quick', form.Flag, 'wifipass_en', _('تخصيص كلمة مرور Wifi'));
		o.rmempty = false;

		o = s.taboption('quick', form.Value, 'wifipass', _('Wifi password'));
		o.password = true;
		o.datatype = 'wpakey';
		o.depends('wifipass_en', '1');

		o = s.taboption('more', form.Value, 'channel2g', _('2.4GHz Channel'));
		o.datatype = 'range(1,14)';
		o.default = '4';

		o = s.taboption('more', form.Value, 'txpower2g', _('2.4GHz Tx power (dBm)'));
		o.datatype = 'range(1,30)';
		o.default = '20';

		o = s.taboption('more', form.Value, 'channel5g', _('5GHz Channel'));
		o.datatype = 'uinteger';
		o.default = '116';

		o = s.taboption('more', form.ListValue, 'htmode5g', _('5GHz Width'));
		o.value('VHT20', '20 MHz');
		o.value('VHT40', '40 MHz');
		o.value('VHT80', '80 MHz');
		o.default = 'VHT40';

		o = s.taboption('more', form.Value, 'txpower5g', _('5GHz Tx power (dBm)'));
		o.datatype = 'range(1,30)';
		o.default = '23';

		o = s.taboption('more', form.Value, 'mesh_id', _('Mesh ID'));
		o.depends('type', 'mesh');
		o.default = 'AL-AMEER-MESH';

		return m.render().then(function (node) {
			var head = E('div', { 'style': 'text-align:center;margin-bottom:1em' }, [
				E('img', { 'src': '/luci-static/alameer/logo.png', 'style': 'max-width:150px;height:auto' })
			]);
			node.insertBefore(head, node.firstChild);
			return node;
		});
	}
});
