$cfgrecorder = Get-CFGConfigurationRecorder
Remove-CFGConfigurationRecorder -ConfigurationRecorderName $cfgrecorder.Name -Force