Before running docker-compose up, you need to do this on _the host_:

Make sure the contents of /etc/modprobe.d/blacklist-rtl2832.conf are:
blacklist rtl2832
blacklist dvb_usb_rtl28xxu
blacklist rtl2832_sdr

echo 'blacklist rtl2832\nblacklist dvb_usb_rtl28xxu\nblacklist rtl2832_sdr' > /etc/modprobe.d/blacklist-rtl2832.conf

Either restart or:

sudo rmmod rtl2832_sdr
sudo rmmod dvb_usb_rtl28xxu
sudo rmmod rtl2832


This keeps the host from binding to the RTL dongle, which allows docker to instead.