@{
    prefix      = "Test"
    body        = (Get-Content ".\Snippets\$($MyInvocation.MyCommand.Name)") -split '\r\n'
    description = "Test Description of Snippet"
}
