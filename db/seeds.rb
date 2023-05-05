# Create drivers
driver_1 = Driver.create(home_address: "8791 S Blue Creek Rd, Evergreen, CO, 80439")
driver_2 = Driver.create(home_address: "4357 Ames St, Denver, CO, 80212")

# Create rides without drivers
Ride.create(start_address: "212 Santa Fe Dr, Denver, CO, 80223", destination_address: "4301 N Pecos St, Denver, CO, 80211")
Ride.create(start_address: "244 Detroit St, Denver, CO, 80206", destination_address: "408 S Nevada, Colorado Springs, CO, 80903")
Ride.create(start_address: "4255 W Colfax Ave, Denver, CO, 80204", destination_address: "27883 Dr, Evergreen, CO, 80439")
Ride.create(start_address: "904 College Ave, Boulder, CO, 80302", destination_address: "3317 E Colfax Ave, Denver, CO, 80206")
Ride.create(start_address: "1510 N Clarkson St, Denver, CO, 80218", destination_address: "3435 W 40th Ave, Denver, CO, 80211")
Ride.create(start_address: "661 Logan St, Denver, CO, 80203", destination_address: "2221 Ford St, Golden, CO, 80401")



# Create rides with drivers
Ride.create(start_address: "2306 Glenarm Pl, Denver, CO, 80205", destination_address: "217 E 7th Ave, Denver, CO, 80203", driver_id: driver_1.id)
Ride.create(start_address: "3249 West Fairview Pl, Denver, CO, 80211", destination_address: "1805 S Bellaire St, Denver, CO,80222", driver_id: driver_2.id)