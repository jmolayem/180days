df <- read.csv("collision.csv", h=T, stringsAsFactors=F)
df$PARTY_TYPE<-factor(df$PARTY_TYPE)
df$PARTY_TYPE<-revalue(df$PARTY_TYPE,c("1"="Driver","2"="Pedestrian","3"="Parked Vehicle","4"="Cyclist","5"="Other","NA"="Not Stated"))
df$PARTY_SOBRIETY<-factor(df$PARTY_SOBRIETY)
df$PARTY_SOBRIETY<-revalue(df$PARTY_SOBRIETY,c("A"="No Drinks","B"="Drunk","C"="Drinks, Not Drunk","D"="Impairment Unknown","G"="Unknown","H"="NA"))
df$PARTY_DRUG_PHYSICAL<-factor(df$PARTY_DRUG_PHYSICAL)
df$PARTY_DRUG_PHYSICAL<-revalue(df$PARTY_DRUG_PHYSICAL,c("E"="Under Drug Influence","F"="Impairment","G"="Unknown","H"="Not Applicable","I"="Sleep"))
df$DIR_OF_TRAVEL<-factor(df$DIR_OF_TRAVEL)
df$PARTY_SAFETY_EQUIP_1<-factor(df$PARTY_SAFETY_EQUIP_1)
df$PARTY_SAFETY_EQUIP_2<-factor(df$PARTY_SAFETY_EQUIP_2)
df$PARTY_SAFETY_EQUIP_2<-revalue(df$PARTY_SAFETY_EQUIP_2,c("A"="None Used","B"="Unknown","C"="Lap Belt Used","D"="Lap Belt Not Used","E"="Shoulder Harness Used","F"="Shoulder Harness Not Used","L"="Air Bag Deployed","M"="Air Bag Not Deployed"))
df$PARTY_SAFETY_EQUIP_2<-factor(df$PARTY_SAFETY_EQUIP_2)
df$FINAN_RESPONS<-factor(df$FINAN_RESPONS)
df$FINAN_RESPONS<-revalue(df$FINAN_RESPONS,c("N"="No Insurance Proof","Y"="Insurance Proof","O"="Not Applicable"))

df$SP_INFO_2<-factor(df$SP_INFO_2)
df$SP_INFO_2<-revalue(df$SP_INFO_2,c("B"="Cell Phone in Use","C"="Cell Phone Not in Use","D"="Unknown"))

df$INATTENTION<-factor(df$INATTENTION)
df$INATTENTION<-revalue(df$INATTENTION,c("A"="Cell Phone","B"="Cell Phone Hands Free","C"="Electronic Equipment","D"="Radio/CD","E"="Smoking","F"="Eating","G"="Children","H"="Animal","I"="Personal Hygiene","J"="Reading"))

df$RACE<-factor(df$RACE)
df$RACE<-revalue(df$RACE,c("A"="Asian","B"="Black","O"="Other","H"="Hispanic","W"="White"))

df$VEHICLE_YEAR<-factor(df$VEHICLE_YEAR)
df$VEHICLE_MAKE<-factor(df$VEHICLE_MAKE)

df$MOVE_PRE_ACC<-factor(df$MOVE_PRE_ACC)
df$MOVE_PRE_ACC<-revalue(df$MOVE_PRE_ACC,c("A"="Stopped","B"="Proceeding Straight","C"="Ran Off Road","D"="Making Right Turn","E"="Making Left Turn","F"="Making U-Turn","G"="Backing","H"="Slowing/Stopping","I"="Passing Other Vehicle","J"="Changing Lanes","K"="Parking Maneuver","L"="Entering Traffic","O"="Parked","P"="Merging","Q"="Traveling Wrong Way"))

