class Serial < ActiveLdap::Base
  ldap_mapping dn_attribute: 'cn', prefix: '', classes: ['device']

  def self.last_uid
    unless serial = Serial.first('lastUID')
      number = User.all.map(&:uid_number)&.max
      number ||= ENV.fetch('MIN_UID_NUMBER', 5000)

      serial = Serial.new
      serial.update_attributes(cn: 'lastUID',  serial_number: number.to_s)
    end
    return serial
  end

  def self.next_uid
    last_uid.serial_number.succ
  end

  def self.increment_uid
    last_uid.update_attributes(serial_number: next_uid)
  end

  def self.last_gid
    unless serial = Serial.first('lastGID')
      number = Group.all.map(&:gid_number)&.max
      number ||= ENV.fetch('MIN_GID_NUMBER', 2000)

      serial = Serial.new
      serial.update_attributes(cn: 'lastGID',  serial_number: number.to_s)
    end
    return serial
  end

  def self.next_gid
    last_gid.serial_number.succ
  end

  def self.increment_gid
    last_gid.update_attributes(serial_number: next_gid)
  end
end
