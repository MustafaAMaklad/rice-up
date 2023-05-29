# rice_up

## ➤Graduation project is: Rice UP

Rice diseases are various and threaten the economy and there are 2 most common diseases in Egypt Brown and Blast these 2 diseases are very similar and cannot differentiate between them in their early stages, So the goal of our application is early detection of these diseases to avoid damages and help user to take an accurate and reliable Decision to improve Rice Quality as possible as.



## ➤Rice UP is an IoT based System that contains mainly 2 features:

1.	IoT with AWS

2.	Image Classification



The first function is about using ESP32 Node MCU with Two sensors moisture and temperature, Start taking readings from the farm, validating, saving them into DynamoDB provisioned with autoscaling and no latency, and sending them to Mobile Application in Real-Time to Monitor readings change over time (monitor factors that may increase diseases) and Show Summary statistics like min, max, and average with readings to handle if there was an outlier reading and provide suggestions and alerts. All statistics are made on OpenSearchService means all computations are made efficiently on the server, not on the client side. We used GraphQl and Restful APIs. Each user monitors his own devices only.



The second Function is a Computer Vision model restricted to the data science lifecycle is used to build an Image Classification model that is able to early detect if the image of rice is diagnosed or not this model is built using ResNet with a High accuracy of the above 97%

## IOT App Integration
![Screenshot 2023-05-29 234244](https://github.com/MohamedWaelAlsayed/rice-up/assets/62488272/d5540a5d-cb2a-49f6-b889-a567ace36654)


![Screenshot 2023-05-29 234315](https://github.com/MohamedWaelAlsayed/rice-up/assets/62488272/00818e88-57d8-42e5-b887-cb7d5dea8d28)

## Deployment of Machine learning Model
![WhatsApp Image 2023-05-30 at 00 42 16](https://github.com/MohamedWaelAlsayed/rice-up/assets/62488272/d3f72f86-49f6-42a2-af99-166956ee6b6e)
