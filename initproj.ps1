# initproj
# Created by David A. Good
# MIT License
# https://github.com/paltamadura/.files

# Initiates a new project by:
#  1. Creating a new public GitHub repo using the name and description provided as command line arguments
#  2. Cloning the newly created repo
#  3. Navigating into the newly created directory containing the cloned repo
#  3. Creating a develop branch and checking it out

# Prerequisites:
#  1. Have PowerShell installed
#  2  Have git installed and GitHub configured as a remote
#  3. Have your GitHub auth token available in an environment variable named GITHUB_AUTH_TOKEN
#  4. Have your GitHub username available in an environment variable named GITHUB_USER_NAME

# Command Line Parameters
# 1. [string] $repoName - Name of the repo
# 2. [string] $repoDescription - Description of the repo
# 3. [boolean] $isPrivate - If the repo should be private (Default value: $false, i.e. public)

# Example Usage
# .\.files\initproj.ps1 my-repo "a repo created with initproj"

# Example Output
# Creating new repo with name [stream-tweets]
# StatusCode        : 201
# StatusDescription : Created
# Content           : {"id":187122846, ...
# ...
# ...
# Cloning into 'stream-tweets'...
# warning: You appear to have cloned an empty repository.
# Switched to a new branch 'develop'

# Notes
# 1. Once you add initial files such as .gitingnore and README.md run `git push -u origin develop`
#    to create the branch on the remote repo (GitHub) and link your local branch with the remote branch

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
