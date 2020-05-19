# HDAC Friday Node Docker

## 빌드하고 노드 실행하기
```/bin/bash
git clone git@github.com:ludorumjeoun/hdac-docker.git
cd ./hdac-docker
./start friday
```
![](https://i.imgur.com/ceOqyJu.png)

## 로그 확인하기
```/bin/bash
docker logs -f friday
```
![](https://i.imgur.com/1xdjgO1.png)




## 컨테이너의 clif를 실행하기
```/bin/bash
./clif friday
```
![](https://i.imgur.com/hTwjw99.png)

## 현재 상태 확인하기
```/bin/bash
./clif friday status
```
![](https://i.imgur.com/G4itrg1.png)


## 키 생성하기
```/bin/bash
./clif friday keys add mykey
```
![](https://i.imgur.com/TKGrB4b.png)

## 컨테이너에서 작업하기

```/bin/bash
./shell friday
cd friday/
```
![](https://i.imgur.com/p3MP37e.png)


### 참고
- https://docs.hdac.io
- https://github.com/hdac-io/friday
- https://github.com/hdac-io/launch