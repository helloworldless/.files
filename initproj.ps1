# initproj
# Created by David A. Good
# https://github.com/paltamadura

# Initiates a new project by:
#  1. Creating a new public GitHub repo using the name and description provided as command line arguments
#  2. Cloning the newly created repo
#  3. Navigating into the newly created directory containing the cloned repo
#  3. Creating a develop branch and checking it out

# Prerequisites:
#  1. Have PowerShell installed
#  1  Have git installed and GitHub configured as a remote
#  1. Have your GitHub auth token available in an environment variable named GITHUB_AUTH_TOKEN
#  2. Have your GitHub username available in an environment variable named GITHUB_USER_NAME

# Command Line Parameters
# 1. [string] $repoName - Name of the repo
# 2. [string] $repoDescription - Description of the repo
# 3. [boolean] $isPrivate - If the repo should be private (Default value: $false, i.e. public)

# Example Usage
# .\.files\initproj.ps1 my-repo "a repo created with initproj"

param([string]$repoName, [string]$repoDescription, [boolean]$isPrivate = $false)
Write-Output "Creating new repo with name [$repoName]"

$body = @{
    name = $repoName
    description = $repoDescription
    private = $isPrivate
}

$uri = "https://api.github.com/user/repos?access_token=$Env:GITHUB_AUTH_TOKEN"

$response = Invoke-WebRequest -Method Post -Uri $uri -Body ($body|ConvertTo-Json) -UseBasicParsing
Write-Output $response

$checkoutCommand = "git clone https://github.com/$Env:GITHUB_USER_NAME/$repoName.git"
Invoke-Expression $checkoutCommand

Set-Location -Path .\$repoName

$createDevelopBranchCommand = "git checkout -b develop"
Invoke-Expression $createDevelopBranchCommand
