Ohai.plugin(:Vboxversion) do
  provides 'vboxversion'

  def from_cmd(cmd)
    so = shell_out(cmd)
    so.stdout.split($INPUT_RECORD_SEPARATOR)[0]
  end

  collect_data do
    if File.exist?('/etc/vboxversion')
      vboxversion_val = File.read('/etc/vboxversion').chomp
    else
      vboxversion_val = from_cmd('dmidecode | grep vboxVer | sed -e "s;^[^_]*_\([0-9.]*\).*$;\1;" | tee /etc/vboxversion')
      Ohai::Log.info('/etc/vboxversion written')
    end
    Ohai::Log.info("vboxversion is #{vboxversion_val}")
    vboxversion vboxversion_val
  end
end
