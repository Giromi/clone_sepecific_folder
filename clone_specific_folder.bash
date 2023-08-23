#!/bin/bash

echo '
|￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣|
|                                                                          |
|                 >> git clone specific branch folder  <<<                 |
|                                                                          |
|                                                    made by. minsuki2     |
|＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿|'

# 인자를 확인하기
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <github_url> <branch> <folder>"
    exit 1
fi

# 인자 추출하기
URL=$1
branch=$2
folder=$3

if [[ $URL == git@github.com* ]]; then
    # SSH URL
    username=$(echo $URL | cut -d':' -f 2 | cut -d'/' -f 1)
    repo=$(echo $URL | cut -d'/' -f 2 | cut -d'.' -f 1)
elif [[ $URL == https://github.com* ]]; then
    # HTTPS URL
    username=$(echo $URL | cut -d'/' -f 4)
    repo=$(echo $URL | cut -d'/' -f 5 | cut -d'.' -f 1)
else
    echo "Invalid GitHub URL. It should be either an SSH or HTTPS URL."
    exit 1
fi

# 디렉토리를 생성하고 이동합니다
mkdir -p ~/Repos/$repo
cd ~/Repos/$repo

# 빈 git 레포지토리를 초기화합니다
git init

# 원격 레포지토리를 추가합니다
git remote add origin $URL

# sparse-checkout을 활성화합니다
git config core.sparseCheckout true
git config pull.rebase true
git config --global init.defaultBranch main



# 원하는 폴더를 sparse-checkout 파일에 추가합니다
echo "$folder/*" >> .git/info/sparse-checkout

# 원격 레포지토리에서 데이터를 가져옵니다
git pull origin $branch

# git을 사용하지 않을 것이기에 지웁니다.
rm -rf .git

# 맨 위로 올려주고
mv $folder ~/Repos
cd ~/Repos

# 지우는 디렉토리를 보여줍니다.
rm -rvf $repo
