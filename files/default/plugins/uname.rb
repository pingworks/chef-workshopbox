Ohai.plugin(:Uname) do
  provides 'uname'

  def from_cmd(cmd)
    so = shell_out(cmd)
    so.stdout.split($INPUT_RECORD_SEPARATOR)[0]
  end

  collect_data do
    unamer_val = from_cmd('uname -r')
    uname unamer_val
  end
end
