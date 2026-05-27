param(
    [Parameter(Mandatory = $true)]
    [string]$UserUpn
)

Install-Module MicrosoftTeams -Scope CurrentUser
Import-Module MicrosoftTeams

Connect-MicrosoftTeams

$results = @()

$teams = Get-Team -User $UserUpn

foreach ($team in $teams) {
    $channels = Get-TeamChannel -GroupId $team.GroupId

    foreach ($channel in $channels) {
        $include = $false

        if ($channel.MembershipType -eq "Standard") {
            $include = $true
        }
        else {
            $members = Get-TeamChannelUser `
                -GroupId $team.GroupId `
                -DisplayName $channel.DisplayName `
                -ErrorAction SilentlyContinue

            if ($members.User -contains $UserUpn) {
                $include = $true
            }
        }

        if ($include) {
            $results += [pscustomobject]@{
                Team        = $team.DisplayName
                Channel     = $channel.DisplayName
                ChannelType = $channel.MembershipType
                TeamId      = $team.GroupId
            }
        }
    }
}

$results | Sort-Object Team, Channel | Format-Table -AutoSize
