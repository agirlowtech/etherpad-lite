# Fork of [Etherpad](https://github.com/ether/etherpad-lite) 

This work is considerd in beta. Use at your own risk.

First deployment was done for [COVID ENTRAIDE France](https://covid-entraide.fr).  
See https://pad.covid-entraide.fr

Help was given by [Agir Low-Tech](https://agir.lowtech.fr/) in context of the [COVID-19 crisis](https://agir.lowtech.fr/t/covid-19/)

## Installation

### 1. Build Container

```
git clone https://github.com/agirlowtech/etherpad-lite.git

cd etherpad-lite

docker build \
-t etherpad:custom \
--build-arg ETHERPAD_PLUGINS="ep_tables3 ep_sticky_attributes ep_stats ep_special_characters ep_set_title_on_pad ep_print ep_pad_activity_nofication_in_title ep_mypads ep_message_all ep_markdown ep_headings2 ep_embedmedia ep_desktop_notifications ep_copy_paste_images ep_page_view ep_horizontal_line ep_comments_page ep_colors ep_chatdate ep_authorship_toggle ep_author_neat ep_align" \
--build-arg NODE_ENV=production \
--no-cache .
```

### 2. Edit or Load your Config

```
vim .env
// edit your .env file with custom passwords, dir, etc...

// load your config
source .env

// edit your APIKEY and SESSIONKEY
echo "${APIKEY}" > ${CONFIG_DIR}/APIKEY.txt
echo "${SESSIONKEY}" > ${CONFIG_DIR}/SESSIONKEY.txt

```

### 3. Copy Container directory

Comment those lines in etherpad section of ```docker-compose.yml```

```
    ...
    volumes:
      - ${CONFIG_DIR}:/opt/etherpad-lite
    ...
```

Copy directory

```
rsync -av ${CONFIG_DIR}/ ${CONFIG_DIR}-backup
rm -rf ${CONFIG_DIR}

// start once so we can copy directory of etherpad container /opt/etherpad-lite 
docker-compose up -d

// copy dir of etherpad container into host
docker cp etherpad:/opt/etherpad-lite/ ${CONFIG_DIR}

// stop & delete containers
docker-compose down && docker-compose rm --force
```

Uncomment lines in ```docker-compose.yml```


### 4. Clean start containers again

```
docker-compose stop && docker-compose rm --force
docker-compose up -d

// remove .env file (security)
rm .env
```

## Architecture

- ```${CONFIG_DIR}``` contains directory used for running etherpad
- ```${DB_DATA_DIR}``` contains and persists postgres data. Removing this directory will clean any data.

## Help 

### How to Run Commands inside container 

```
docker exec -it etherpad /bin/bash

// then you're into the container
$ npm install ...

```

### Cleaning Database 


```
rm -rf ${DB_DATA_DIR}
dc-srul
```

### Accessing Admin Web Interface

- Etherpad : https://your.domain.com/admin
- MyPads : https://your.domain.com/mypads/?/admin
