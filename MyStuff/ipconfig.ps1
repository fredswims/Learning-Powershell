 ipconfig | Where-Object { $_ -like '*IPv4*' } |ForEach-Object { ($_ -split ': ')[1] }
