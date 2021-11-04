# HelloIotCloud

[TORIFUKUKaiou/temperature_and_humidity_nerves](https://github.com/TORIFUKUKaiou/temperature_and_humidity_nerves)でNervesデバイス（Raspberry Pi）から打ち上がってくる温湿度値の値をグラフ表示するPhoenix Webアプリ．
うねうねしてます．Dockerでイゴかせます．

## ローカルPCに展開する場合

macOS CatalinaとDocker Desktopで動作を確かめてみます．
Ubuntuでも動くはずですが，その場合は `docker compose` -> `sudo docker-compose` に読み替えてください．

1. .envファイルを用意する
    - `EMAIL` はご自身のもので
    - `VIRTUAL_HOST` は，localhostではなくIP直打ちにしてください（NervesからIP指定でpostするため）
    ```
    $ cp .env.sample .env
    $ vim .env
    $ cat .env
    EMAIL=hoge@gmail.com
    VIRTUAL_HOST=192.168.1.2
    ```
2. Docker内でPhoenixを立ち上げる
    ```
    $ docker compose config
    $ docker compose up
    ```
3. Webブラウザでアクセス！
    http://192.168.1.2
4. [TORIFUKUKaiou/temperature_and_humidity_nerves](https://github.com/TORIFUKUKaiou/temperature_and_humidity_nerves)から飛んできた温度がうねうねしていることを確認する
    http://192.168.1.2/temperature-chart

## Azure VMに展開する場合

Microsoft AzureにUbuntuイメージのVMを立ち上げて展開する場合です．所定のVM利用料が発生しますので，自己責任で行ってください（参考：[料金 - Linux Virtual Machines | Microsoft Azure](https://azure.microsoft.com/ja-jp/pricing/details/virtual-machines/linux/)

2021年11月30日までは，下記を公開しています．単純にクラウドに打ち上げたい用途でしたらご利用ください．ただしセキュリティ対策はきちんと設定していませんので，自己責任でご利用ください．  
https://nervesjp-dsf2021.japaneast.cloudapp.azure.com/

### Azure VMの設定

1. Virtual Machinesを作成
    - サブスクリプションや仮想マシン名などはご自身の設定で
    - イメージは "Ubuntu Server 20.04 LTS - Gen2"
    - サイズは "Standard_B1s" で十分です
    - OSディスクの種類は "Standard SSD" で十分です
    - その他の設定はデフォルト
2. ネットワークの設定
    - 仮想マシンの左メニューバー「ネットワーク」を選択
      - 受信ポートの規則：HTTP, HTTPSを追加する
      - 送信ポートの規則：HTTP, HTTPSを追加する
    - 仮想マシンのメニューの「DNS名」を選択
      - 「IPアドレスの割り当て」を "静的" に変更
      - 「DNS名ラベル」をお好きなものに設定（例： "nervesjp-dsf2021"）
    - 仮想マシンを再起動する
3. sshログインしていろいろ設定する
    ```
    $ cp ~/Download/<your_key>_key.pem ~/.ssh/
    $ chmod 400 ~/.ssh/<your_key>_key.pem
    $ ssh -i ~/.ssh/<your_key>_key.pem azureuser@<your_domain>.japaneast.cloudapp.azure.com
    ```
    - [スワップ領域を追加](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-20-04-ja)する
    ```
    $ sudo fallocate -l 1G /swapfile
    $ sudo chmod 600 /swapfile
    $ sudo mkswap /swapfile
    $ sudo swapon /swapfile
    $ sudo swapon --show
    NAME      TYPE  SIZE USED PRIO
    /swapfile file 1024M   0B   -2
    ```
    - [Docker Engine on Ubuntuをインストール](https://docs.docker.com/engine/install/ubuntu/)する(ry
    - `docker-compose`をインストールする
    ```
    $ sudo apt-get install docker-compose
    ```

### Phoenixアプリの展開

```
$ git clone https://github.com/TORIFUKUKaiou/hello_iot_cloud.git
### .envファイルの用意
$ cp .env.sample .env
$ vim .env
$ cat .env
EMAIL=hoge@gmail.com
VIRTUAL_HOST=<your_domain>.japaneast.cloudapp.azure.com
### WebアプリケーションのRun
sudo docker-compose config
sudo docker-compose up -d
```

あとは[TORIFUKUKaiou/temperature_and_humidity_nerves](https://github.com/TORIFUKUKaiou/temperature_and_humidity_nerves)から飛んできたうねうねをお楽しみください :rocket:  
https://<your_domain>.japaneast.cloudapp.azure.com/temperature-chart

## Original README

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
