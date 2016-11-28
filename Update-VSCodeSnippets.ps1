function Update-VSCodeSnippets
{
    [CmdletBinding()]
    Param
    (
        [String]$Language = 'PowerShell',

        [Switch]$Insiders
    )

    Begin
    {
        if ($Insiders)
        {
            $CodeDir = 'Code - Insiders'
        }
        else
        {
            $CodeDir = 'Code'
        }
    }

    Process
    {
        $JsonPath = "$ENV:AppData\$CodeDir\User\snippets\$Language.json"
        if (Test-Path $Path)
        {
            $CurrentSnippets = Get-Content -Path $JsonPath -Raw | ConvertFrom-Json
        }
        else
        {
            $Null = New-Item -Path $JsonPath
            $CurrentSnippets = @{}
        }

        $SnippetsMetadata = Get-ChildItem -Path $PSScriptRoot\Metadata

        foreach ($Metadata in $SnippetsMetadata)
        {
            $SnippetName = [io.path]::GetFileNameWithoutExtension($($Metadata.Name))
            $Snippet = . $Metadata.Fullname

            if (!$CurrentSnippets.$SnippetName)
            {
                $CurrentSnippets | Add-Member -MemberType NoteProperty -Name $SnippetName -Value $Snippet
            }
            else
            {
                if ($CurrentSnippets.$SnippetName.prefix -ne $Snippet.prefix)
                {
                    $CurrentSnippets.$SnippetName.prefix = $Snippet.prefix
                }

                if ($CurrentSnippets.$SnippetName.description -ne $Snippet.description)
                {
                    $CurrentSnippets.$SnippetName.description = $Snippet.description
                }

                if ($CurrentSnippets.$SnippetName.body -ne $Snippet.body)
                {
                    $CurrentSnippets.$SnippetName.body = $Snippet.body
                }
            }
            ($CurrentSnippets) | ConvertTo-Json | Out-File C:\TestPowerShell.json -Encoding ascii -force
        }
    }
}