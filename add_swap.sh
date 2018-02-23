SWAPFILE="/swap.$(($(ls /swap.* | wc -l)+1))"
sudo fallocate -l 4G $SWAPFILE
sudo chmod 600 $SWAPFILE
sudo mkswap $SWAPFILE
sudo swapon $SWAPFILE
sudo swapon --show
