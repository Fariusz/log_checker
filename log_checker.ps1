$Date = (get-date).ToString(‘yyyy-MM-dd’)
#===MAIL CONFIG=======================================
$smtp = 'smtp.company.i'
$MailText = "mail body "
$Subject = "mail subject " + $Date 
$Recipient = 'recipient@company.com'
$Sender = 'sender@company.com'

function Send-Mail
{
    param($MailText)
    send-mailmessage -to $Recipient -from $Sender -subject $Subject -body $MailText -smtpServer $smtp -ErrorAction Stop –Encoding ([System.Text.Encoding]::UTF8)
}

#===LOG CHECK=======================================
$WantFile = "\\server\scripts\logs\logname_$Date.log"
$Exists = Test-Path -Path $WantFile
$FileExists = Test-Path $WantFile

If ($FileExists -eq $True)
{
    $SEL = Select-String -Path $WantFile -Pattern "Total failed to send = 0"
    If ($SEL -ne $null) {\\do smthg if OK}
    Else
    {
	$MailText = Select-String -Pattern "input what you are looking for in log" -Path $WantFile -Context 5,3 | Select-Object -ExpandProperty Line
        $MailText = "Input what you want to send via mail part 1 `n`n`n" + $MailText + "`n`n`n part 2  " + $WantFile
        Send-Mail -$MailText
    }
}
Else 
{
    $MailText = "Input what you want to send via mail" + $Date
    Send-Mail -$MailText
}
   


