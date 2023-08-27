# hakoniwa-mros2sim



## 環境

* サポートOS
  * Arm系Mac (M1Mac, M2Mac)
* 利用する環境
  * Docker Desktop
  * インストールを実施する場合は、事前に、Docker Desktop を起動してください。
* 利用するロボット
  * https://github.com/toppers/hakoniwa-unity-picomodel
  * 本リポジトリと同じ階層でクローンしてください。
  * ディレクトリ構成
    * hakoniwa-unity-picomodel
    * hakoniwa-mros2sim
* ロボット制御プログラム
  * TODO

## 事前準備

２つのリポジトリをクローンします。

```
git clone --recursive https://github.com/toppers/hakoniwa-mros2sim.git
```

```
git clone --recursive https://github.com/toppers/hakoniwa-unity-picomodel.git
```

クローン完了後、picomodel のインストール手順に従って、picomodelをUnity上で表示できるようにしてください。


## hakoniwa-mros2sim のインストール手順


```
cd hakoniwa-mros2sim
```

```
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
```

```
bash docker/run.bash en0
```

docker コンテナ内で以下のコマンドを実行して箱庭プロキシのコードを生成します。

```
cd hakoniwa-ros2pdu
```

```
bash create_all_pdus.bash
```

成功すると、こうなります。

```
#### Creating pico_msgs/LightSensor ####
#### Creating geometry_msgs/Twist ####
#### Creating geometry_msgs/Vector3 ####
```

```
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


## シミュレーション実行手順

### 箱庭とmros2プロキシを起動する

ホストPC上で、以下のコマンドを実行して、箱庭とmros2プロキシを起動します。

```
bash workspace/runtime/run.bash
```

成功すると、こうなります。

```
INFO: ACTIVATING HAKO-CONDUCTOR
delta_msec = 20
max_delay_msec = 100
INFO: shmget() key=255 size=1129352 
Server Start: 127.0.0.1:50051
INFO: ACTIVATING binary:mros2-posix
START:hako_pdu_proxy_node
ipaddr=0x270ba8c0
mask=0x00ffffff
LOG_NOTICE : 00000000.000 : osKernelStart
mros2-posix start!
app name: hako_pdu_proxy(mros2-posix)
LOG_DEBUG : 00000000.000 : mROS 2 initialization is completed

LOG_DEBUG : 00000000.000 : [MROS2LIB] create_node
LOG_DEBUG : 00000000.000 : [MROS2LIB] start creating participant
LOG_DEBUG : 00000000.000 : [MROS2LIB] mros2_init task start
LOG_DEBUG : 00000000.000 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_init() 28: enter
LOG_DEBUG : 00000000.000 : [MROS2LIB] Initilizing lwIP complete
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 306: enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 24: enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 42: mcp=0x144804080 exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 326: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 141: ipaddr=0x0 port=7401 enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 154: mcp exist 0x144804080
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 224: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 239: enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 250: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 306: enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 24: enter
LOG_NOTICE : 00000000.001 : thread_udp_recv:UP: mcp=0x144804080
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 42: mcp=0x1448040a0 exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 326: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 141: ipaddr=0x0 port=7400 enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 154: mcp exist 0x1448040a0
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 224: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 239: enter
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 250: exit
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_joingroup() 78: enter ifaddr=0x270ba8c0 groupaddr=0x100ffef
LOG_NOTICE : 00000000.001 : thread_udp_recv:UP: mcp=0x1448040a0
LOG_NOTICE : 00000000.001 : udp_mc_joingroup(): mcp=0x144804080 ifaddr=0x270ba8c0 groupaddr=0x100ffef
LOG_NOTICE : 00000000.001 : udp_mc_joingroup(): mcp=0x1448040a0 ifaddr=0x270ba8c0 groupaddr=0x100ffef
LOG_DEBUG : 00000000.001 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_joingroup() 93: exit
LOG_DEBUG : 00000000.105 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 306: enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 24: enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 42: mcp=0x1448040c0 exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 326: exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 141: ipaddr=0x0 port=7411 enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 154: mcp exist 0x1448040c0
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 224: exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 239: enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 250: exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 306: enter
LOG_NOTICE : 00000000.106 : thread_udp_recv:UP: mcp=0x1448040c0
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 24: enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp_multicast_manager.c udp_mc_info_alloc() 42: mcp=0x1448040e0 exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_new() 326: exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 141: ipaddr=0x0 port=7410 enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 154: mcp exist 0x1448040e0
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_bind() 224: exit
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 239: enter
LOG_DEBUG : 00000000.106 : /Users/tmori/project/oss/test/hakoniwa-mros2sim/hakoniwa-ros2pdu/mros2-posix/lwip-posix/src/core/udp.c udp_recv() 250: exit
LOG_NOTICE : 00000000.106 : thread_udp_recv:UP: mcp=0x1448040e0
LOG_DEBUG : 00000000.106 : [MROS2LIB] successfully created participant
LOG_DEBUG : 00000000.106 : [MROS2LIB] create_publisher complete.
INFO: PicoModel create_lchannel: logical_id=1 real_id=0 size=48
LOG_DEBUG : 00000000.107 : [MROS2LIB] create_subscription complete.
LOG_DEBUG : 00000000.206 : [MROS2LIB] Initilizing Domain complete
START
Press ENTER to stop...
```

## ROS2のpicomodel制御プログラムを起動する

Unityのシミュレーションボタンを押下します。

成功するとこうなります。コンソール上にもエラーが出力されていないことを確認してください。

![スクリーンショット 2023-08-28 8 13 12](https://github.com/toppers/hakoniwa-mros2sim/assets/164193/ba814c0b-ce4f-4905-bc7f-5e17fc3fe4a6)

## Unity のシミュレーションを開始する

シミュレーションを開始するには、Unityの画面左上の `START` ボタンをクリックしてください。

成功すると下図のように、シミュレーション時間が増えていきます。

![スクリーンショット 2023-08-28 8 14 51](https://github.com/toppers/hakoniwa-mros2sim/assets/164193/80da8d6a-5364-415c-8ac1-bffee49b932a)


## シミュレーションを停止する

シミュレーションを停止する場合は、Unityのシミュレーションボタンを押して、Unity側のシミュレーションを終了させます。 次に、`run.bash` のターミナルで `Enterキー` を押下して停止します。

