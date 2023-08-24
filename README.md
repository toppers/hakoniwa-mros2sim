# hakoniwa-mros2sim

## 環境

* サポートOS
  * Arm系Mac (M1Mac, M2Mac)
* 利用する環境
  * Docker Desktop

インストールを実施する場合は、事前に、Docker Desktop を起動してください。

## インストール手順

リポジトリをクローンします。

```
git clone --recursive https://github.com/toppers/hakoniwa-mros2sim.git
cd hakoniwa-mros2sim
git submodule update --init --recursive
```

必要なファイルをコピーします。

```
bash  utils/install-sampe.bash 
```

### 箱庭プロキシ(mros2)のコード生成

docker コンテナ上で、箱庭プロキシ(mros2)のコードを生成します。

まず、docker コンテナを起動しましょう。

```
cd hakoniwa-ros2pdu
bash docker/run.bash en0
```

docker コンテナ内で以下のコマンドを実行して箱庭プロキシのコードを生成します。

```
cd hakoniwa-ros2pdu
bash create_all_pdus.bash
bash create_proxy.bash ./config/custom.json 
```

成功すると以下のファイルが出力されます。

```
# ls pdu/types/pico_msgs/
pdu_ctype_LightSensor.h  pdu_ctype_conv_LightSensor.hpp

# ls workspace/src/hako_pdu_proxy/src/gen/
app.cpp  hako_pdu_proxy_com_pub.cpp  hako_pdu_proxy_com_sub.cpp
```

### 箱庭プロキシ(mros2)のビルド

箱庭プロキシ(mros2)をビルドするために、ホストPC上で、hakoniwa-ros2pduに移動します。

```
cd hakoniwa-ros2pdu
```

ビルドコマンドを実行します。

ビルドコマンドの仕様は以下のとおりです。

```
Usage: build_mros2proxy.bash <custom.json> <ipaddr> [<netmask>]
```

* custom.json は、`config/custom.json` を指定します。
* ipaddr は、ホストPCのIPアドレスを指定します。
* netmask は、ホストPCのネットマスクを指定します。未指定の場合は、`255.255.255.0`となります。


以下、実行例です。

```
 bash build_mros2proxy.bash ./config/custom.json 192.168.11.39
```

成功すると、以下のファイルが出力されます。

```
% file mros2-posix/cmake_build/mros2-posix
mros2-posix/cmake_build/mros2-posix: Mach-O 64-bit executable arm64
```

このファイルを以下にコピーしてください。

* /usr/local/bin/hakoniwa

```
sudo cp mros2-posix/cmake_build/mros2-posix /usr/local/bin/hakoniwa/
```

## 箱庭コア機能のインストール

箱庭コア機能をホストPC上でインストールします。

```
cd hakoniwa-core-cpp-client 
bash build.bash
bash install.bash
```
途中でパスワードを聞かれますので、入力してください。
成功すると、以下にバイナリが配置されます。

* /usr/local/lib/hakoniwa 
* /usr/local/bin/hakoniwa 

## 箱庭コンダクタのインストール

箱庭コンダクタをホストPC上でインストールします。

```
cd hakoniwa-conductor/main
bash build.bash
sudo bash install.bash
```

途中でパスワードを聞かれますので、入力してください。
成功すると、以下にバイナリが配置されます。

* /usr/local/bin/hakoniwa 
