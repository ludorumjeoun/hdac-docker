# HDAC Friday Node Docker

## 빌드하고 노드 실행하기
```/bin/bash
git clone git@github.com:ludorumjeoun/hdac-docker.git
cd ./hdac-docker
./start friday
```

## 컨테이너의 clif를 실행하기
```/bin/bash
./clif friday
```

## 키 생성하기
```/bin/bash
./clif friday keys add mykey
Enter a passphrase to encrypt your key to disk:
./clif friday keys list
```

## 키 생성하기
```/bin/bash
./clif friday keys $KEY_NAME
```

## 컨테이너에서 작업하기
```/bin/bash
./shell friday
```


### 참고
- https://docs.hdac.io
- https://github.com/hdac-io/friday
- https://github.com/hdac-io/launch