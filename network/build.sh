#!/bin/bash
#
# Exit on first error, print all commands.
set -e

#Start from here
echo -e "\nStopping the previous network (if any)"
docker-compose -f docker-compose.yml down

# If need to re-generate the artifacts, uncomment the following lines and run
#
cryptogen generate --config=./crypto-config.yaml
mkdir config
configtxgen -profile OneOrgOrdererGenesis -outputBlock ./config/genesis.block
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID mychannel
configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
# configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
#
# Create and Start the Docker containers for the network
echo -e "\nSetting up the Hyperledger Fabric 1.1 network"
docker-compose -f docker-compose.yml up -d
sleep 15
echo -e "\nNetwork setup completed!!\n"

