#!/bin/bash

# Set default values for variables
SUBNET_CALCULATED=0

# Define the function to calculate subnet information
calculate_subnet() {
  IPADDR=$1
  MASK=$2

  # Check if the input IP address and subnet mask are valid
  if ! echo $IPADDR | grep -q '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]+$'; then
    echo "Invalid IP address or subnet mask. Please use the format: 192.168.1.1/24"
    SUBNET_CALCULATED=1
    return 1
  fi

  # Extract the IP address and subnet mask from the CIDR notation
  IP=$(echo $IPADDR | cut -d '/' -f 1)
  MASK=$(echo $IPADDR | cut -d '/' -f 2)

  # Check if the subnet mask is a valid decimal value between 0 and 32
  if ! [[ $MASK =~ ^[0-9]+$ ]] || (( $MASK < 0 )) || (( $MASK > 32 )); then
    echo "Invalid subnet mask. Please use a decimal value between 0 and 32."
    SUBNET_CALCULATED=1
    return 1
  fi

  # Calculate the subnet mask in dotted decimal notation
  SUBNET_MASK=$((2**32-2**($MASK)))
  SUBNET_MASK=$(printf '%b' 0x$(printf '%08b' $((2**32-2**($MASK)))) | sed 's/0*//' | tr '\n' '.')

  # Calculate the network address (IPv4 only)
  NETWORK_ADDRESS=$(echo $IP | cut -d '.' -f 1,2,$(((MASK)/8+1)),. )

  # Calculate the broadcast address (IPv4 only)
  BROADCAST_ADDRESS=$(echo $IP | cut -d '.' -f 1,2,$((32-$MASK)),4)

  # Calculate the hosts per subnet
  HOSTS_PER_SUBNET=$((2**32-2**($MASK)))

  echo "Subnet mask: $SUBNET_MASK"
  echo "Network address: $NETWORK_ADDRESS"
  echo "Broadcast address: $BROADCAST_ADDRESS"
  echo "Hosts per subnet: $HOSTS_PER_SUBNET"
}

# Parse command-line arguments
while getopts ":h:i:m:" opt; do
  case $opt in
    h) HELP=1;;
    i) IPADDR=$OPTARG;;
    m) MASK=$OPTARG;;
    \?) echo "Invalid option -$OPTARG"; SUBNET_CALCULATED=1;;
  esac
done

# Check if the help flag was set
if [ $HELP ]; then
  echo "Usage: $(basename $0) [-h] [-i IPADDR] [-m MASK]"
  echo "  -h   Display this help message"
  echo "  -i   Specify the IP address (e.g., 192.168.1.1)"
  echo "  -m   Specify the subnet mask (e.g., 24)"
  exit
fi

# Call the function to calculate the subnet information
calculate_subnet $IPADDR $MASK

if [ $SUBNET_CALCULATED ]; then
  exit 1
fi