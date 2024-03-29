library(BatchGetSymbols)
library(dplyr)
#install.packages('ggthemes')
library(ggthemes)
library(ggplot2)
library(e1071)
library(ggmap)
library(rpivotTable)
library(rvest)
library(foreign)
library(readxl)
x=read.csv(file.choose(),sep=',',header=T)
#install.packages('plotly')
library(plotly)
options(scipen = 999)
library(readr)
library(purrr)
library(gridExtra)
library(tidyr)
library(psych)
library(HSAUR2)
library(lubridate)
library(RJSONIO)
library(jsonlite)
library(mice)
library(tm)
library(networkD3)
library(twitteR)
library(plotrix)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## importing dataset

yr_12_15 = read.csv('D:/study/datasets/Global Terror Attach data set and Code book/gtd_12to15_52134.csv')
yr_70_91 = read.csv('D:/study/datasets/Global Terror Attach data set and Code book/gtd_70to91_49566.csv')
yr_92_11 = read.csv('D:/study/datasets/Global Terror Attach data set and Code book/gtd_92to11_no 93_55072.csv')
yr_93 = read.csv('D:/study/datasets/Global Terror Attach data set and Code book/gtd1993_748.csv')
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Q1. no of attacks per year

df1 = yr_70_91 %>% select(iyear)
df2 = yr_92_11 %>% select(iyear)
df3 = yr_93 %>% select(iyear)
df4 = yr_12_15 %>% select(iyear)

no_of_attacks = rbind(df1,df2,df3,df4) %>% group_by(iyear) %>% summarise(total_attacks = n())

## ggplot
scale_x_continuous(breaks = c(1970:2015))
area = ggplot(no_of_attacks, aes(iyear, total_attacks)) + scale_x_continuous(breaks = c(1970:2015)) +
  theme_dark() + theme(axis.text.x = element_text(angle = 45, vjust = .6)) + geom_point() +
  geom_area(size = .8, color = 'black', fill = 'tomato2', alpha = .8) +
  labs(title = 'Total Number of attacks per year',
       x = 'Year',
       y = 'Attacks')
#area
ggplotly(area)
# 
# 
# no_of_attacks$iyear = as.factor(no_of_attacks$iyear) #changing char to factor
# 
# bar = ggplot(no_of_attacks, aes(x = iyear, y = total_attacks)) +
#   geom_bar(stat = 'Identity', width = 0.7, fill = 'tomato2') + theme_classic() + theme_gray() +
#   theme(axis.text.x = element_text(angle = 45, vjust = .6))+
#   labs(title = 'No. of Attacks per Year',
#        x = 'Year',
#        y = 'Attacks')
# bar
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Question 2) no of bombing per  year

df2_1 = yr_70_91 %>% filter(attacktype1_txt == 'Bombing/Explosion') %>% select(iyear)
df2_2 = yr_92_11 %>% filter(attacktype1_txt == 'Bombing/Explosion') %>% select(iyear)
df2_3 = yr_93 %>% filter(attacktype1_txt == 'Bombing/Explosion') %>% select(iyear)
df2_4 = yr_12_15 %>% filter(attacktype1_txt == 'Bombing/Explosion') %>% select(iyear)

total_bomb_py = rbind(df2_1,df2_2,df2_3,df2_4) %>% group_by(iyear) %>% summarise(tot_bom = n())

# total_bomb_py$iyear = as.factor(total_bomb_py$iyear)
# 
# bar_bomb = ggplot(total_bomb_py, aes(x = iyear, y = tot_bom)) +
#   geom_bar(stat = 'Identity', width = 0.7, fill = 'snow') + theme_classic() + theme_dark() +
#   theme(axis.text.x = element_text(angle = 45, vjust = .6))+
#   labs(title = 'No. of Bombings per Year',
#        x = 'Year',
#        y = 'Bombings')
# bar_bomb

comb = merge(x= no_of_attacks,
             y = total_bomb_py,
             by.x = 'iyear',
             by.y = 'iyear',
             all.x = TRUE)

comb$iyear = as.Date(comb$iyear, '%Y') #converting char year to typical year

stack_area = ggplot(comb, aes(iyear)) +  
  scale_x_continuous(breaks = c(1970:2015)) +
  geom_area(aes(y = total_attacks, col = 'Total Attacks'), fill='lightsalmon3', size= 0.8, alpha = .8) +
  geom_point(aes(y = total_attacks)) +
  geom_area(aes(y = tot_bom, col = 'Total bombings'), fill = 'aquamarine3', size = .8, alpha = .6) + 
  geom_point(aes(y = tot_bom)) +
  theme_economist_white() + 
  theme(axis.text.x = element_text(angle = 45, vjust = .6),
        legend.position = c(.1,0.9),
        legend.title = element_blank()) +
  labs(title = 'Comparision between Number of Attacks and Bombings per year',
       x = 'Year',
       y = ' ')
stack_area
ggplotly(stack_area)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# QUESTION 3. 

df3_1 = yr_70_91 %>% group_by(iyear, region_txt) %>% summarise(total_attacks = n())
df3_2 = yr_92_11 %>% group_by(iyear, region_txt) %>% summarise(total_attacks = n())
df3_3 = yr_93 %>% group_by(iyear, region_txt) %>% summarise(total_attacks = n())
df3_4 = yr_12_15 %>% group_by(iyear, region_txt) %>% summarise(total_attacks = n())

reg_wise_att = rbind(df3_1,df3_2,df3_3,df3_4)

reg_wise_att$iyear = as.factor(reg_wise_att$iyear)

reg_wise = ggplot(reg_wise_att , aes(x=region_txt, y=iyear)) + 
  geom_point(aes(col=region_txt, size=total_attacks)) + theme_gray() +
  theme(axis.text.x = element_blank(),
        legend.title = element_blank()) +
  labs(y="Year", 
       x="Region", 
       title="Region-wise attacks per year")
reg_wise
ggplotly(reg_wise)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## Question 4.

yr_93$region_txt[394] = 'Eastern Europe'
yr_93$region_txt[412] = 'Eastern Europe'
yr_93$region_txt[507] = 'Eastern Europe'
yr_93$region_txt[733] = 'Eastern Europe'
yr_93$region_txt[423] = 'Eastern Europe'
yr_93$region_txt[429] = 'Eastern Europe'
yr_93$region_txt[514] = 'Eastern Europe'
yr_93$region_txt[536] = 'Eastern Europe'
yr_93$region_txt[538] = 'Eastern Europe'

d4_1 = yr_70_91 %>% group_by(region_txt, attacktype1_txt) %>% summarise(total_attacks = n())
d4_2 = yr_92_11 %>% group_by(region_txt, attacktype1_txt) %>% summarise(total_attacks = n())
d4_3 = yr_93 %>% group_by(region_txt, attacktype1_txt) %>% summarise(total_attacks = n())
d4_4 = yr_12_15 %>% group_by(region_txt, attacktype1_txt) %>% summarise(total_attacks = n())


reg_wise_att_t5 = rbind(d4_1,d4_2,d4_3,d4_4) %>% 
  group_by(region_txt, attacktype1_txt) %>% 
  summarise(total_attacks = sum(total_attacks)) %>% top_n(5)

top.5.att.r.w = ggplot(reg_wise_att_t5, aes(attacktype1_txt, total_attacks)) +
  geom_bar(stat = 'Identity', width = .5, aes(fill = attacktype1_txt))+
  theme_stata()+
  theme(axis.text.x = element_blank(),
        axis.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(angle = 0),
        legend.title = element_blank(),
        legend.position = 'bottom') +
  facet_wrap(~region_txt)

top.5.att.r.w
ggplotly(top.5.att.r.w)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## Question 5.

df5_1 = yr_70_91 %>% group_by(targtype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))
df5_2 = yr_92_11 %>% group_by(targtype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))
df5_3 = yr_93 %>% group_by(targtype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))
df5_4 = yr_12_15 %>% group_by(targtype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))

hvy_hit = rbind(df5_1, df5_2, df5_3, df5_4) %>% group_by(targtype1_txt) %>%
  summarise(kills = round(sum(kills),0),
            wound = round(sum(wound),0),
            total = kills + wound) %>% arrange(-total) %>% head(10)

hvy_hit_pie = plot_ly(hvy_hit, labels = ~targtype1_txt, values = ~total, 
                      type = 'pie', pull = .01, textposition = 'inside') %>%
  layout(title = 'HEAVIEST HIT TARGET TYPE.',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

hvy_hit_pie
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## Question 6

str(yr_70_91)
df6_1 = yr_70_91 %>% filter(country_txt %in% c('Pakistan','India'))%>%
  group_by(iyear ,country_txt) %>%
  summarise(total_attacks = n())

df6_2 = yr_92_11 %>% filter(country_txt %in% c('Pakistan','India'))%>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

df6_3 = yr_93 %>% filter(country_txt %in% c('Pakistan','India'))%>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

df6_4 = yr_12_15 %>% filter(country_txt %in% c('Pakistan','India'))%>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

ind_pak = rbind(df6_1,df6_2,df6_3,df6_4) %>% group_by(iyear, country_txt) %>%
  summarise(total_attacks = sum(total_attacks))


ivp_comp = ggplot(ind_pak, aes(iyear, total_attacks)) +
  geom_area(aes(fill = country_txt), size = 1.2, 
            color = 'black',alpha = .8)+ 
  geom_point(size = 2) +
  theme_grey()+
  theme(legend.title = element_blank(), 
        legend.position = 'none') +
  labs(title = 'INDIA vs. PAKISTAN',
       x = 'Years',
       y = 'Attacks') +
  facet_wrap(~country_txt)

ivp_comp

ggplotly(ivp_comp)

####################################################### 
# ind = ind_pak %>% filter(country_txt == 'India')
# pak = ind_pak %>% filter(country_txt == 'Pakistan')
# 
# ip = ggplot(ind, aes(iyear, total_attacks)) + #scale_x_continuous(breaks = c(1970:2015)) +
#   theme_grey() + theme(axis.text.x = element_text(angle = 45, vjust = .6)) + geom_point() +
#   geom_area(size = .8, color = 'black', fill = 'orangered2', alpha = .8) +
#   labs(title = 'Total Number of attacks per year in India',
#        x = 'Year',
#        y = 'Attacks')
# 
# pp = ggplot(pak, aes(iyear, total_attacks)) +# scale_x_continuous(breaks = c(1970:2015)) +
#   theme_gray() + theme(axis.text.x = element_text(angle = 45, vjust = .6)) + geom_point() +
#   geom_area(size = .8, color = 'black', fill = 'green4', alpha = .8) +
#   labs(title = 'Total Number of attacks per year in Pakistan',
#        x = 'Year',
#        y = 'Attacks')
# 
# grid.arrange(ip, pp, nrow = 1)
#####################################

# ########################################################
# ivplong = spread(ind_pak, country_txt, total_attacks)
# 
# stack_ivp = ggplot(ivplong, aes(iyear)) +
#   scale_x_continuous(breaks = c(1970:2015)) +
#   geom_area(aes(y = Pakistan, col = 'Pakistan'), fill = 'green4', size = .8, alpha = .8) +
#   geom_point(aes(y = Pakistan)) +
#   geom_area(aes(y = India, col = 'India'), fill='orangered2', size= 0.8, alpha = .8) +
#   geom_point(aes(y = India)) +
#   theme_economist_white() +
#   theme(axis.text.x = element_text(angle = 45, vjust = .6),
#         legend.position = c(.1,0.9)) +
#   labs(title = 'Comparision between Number of Attacks and Bombings per year',
#        x = 'Year',
#        y = ' ')
# 
# stack_ivp
##################################################################

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## Question 7

df7_1 = yr_70_91 %>% filter(country_txt %in% c('United States', 'Soviet Union')) %>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

df7_2 = yr_92_11 %>% filter(country_txt %in% c('United States', 'Russia')) %>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

df7_3 = yr_93 %>% filter(country_txt %in% c('United States', 'Russia')) %>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())

df7_4 = yr_12_15 %>% filter(country_txt %in% c('United States', 'Russia'))%>%
  group_by(iyear, country_txt) %>%
  summarise(total_attacks = n())


df7_5 = rbind(df7_1,df7_2,df7_3,df7_4) %>%
  group_by(iyear, country_txt) %>% summarise(total_attacks = sum(total_attacks))

df7_5$country_txt[9] = 'Russia' # to change soviet union into russia
df7_5$country_txt[21] = 'Russia'
df7_5$country_txt[23] = 'Russia'
df7_5$country_txt[25] = 'Russia'

df7_6 = df7_5 %>% group_by(iyear, country_txt) %>% 
  summarise(total_attacks = sum(total_attacks)) # adding up to the total

usvr_comp = ggplot(df7_6, aes(iyear, total_attacks)) +
  geom_area(aes(fill = country_txt), size = 1.2, 
            color = 'black',alpha = .8)+ 
  geom_point(size = 2) +
  theme_economist_white()+
  theme(legend.title = element_blank(), 
        legend.position = 'none') +
  labs(title = 'United States vs Russia.',
       x = 'Years',
       y = 'Attacks') +
  facet_wrap(~country_txt)

usvr_comp

ggplotly(usvr_comp)
################################################################################################

########################################################################################################
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Question 8


df8_1 = yr_70_91 %>% group_by(country_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))
df8_2 = yr_92_11 %>% group_by(country_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))
df8_3 = yr_93 %>% group_by(country_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                        wound = sum(nwound, na.rm = TRUE))
df8_4 = yr_12_15 %>% group_by(country_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                           wound = sum(nwound, na.rm = TRUE))

most_casualties = rbind(df8_1,df8_2,df8_3,df8_4) %>% group_by(country_txt) %>% 
  summarise(kills = round(sum(kills),0),
            wound = round(sum(wound),0),
            total_casualties = kills + wound) %>% arrange(-total_casualties) %>%
  head(15)

cas_bar = ggplot(most_casualties, 
                 aes(x = reorder(country_txt, -total_casualties), y = total_casualties)) +
  geom_bar(stat = 'Identity', width = 0.7, aes(fill = country_txt)) + theme_economist() +
  theme(legend.title = element_blank(),
        legend.position = 'none')+
  labs(title = 'Most affected Countries.',
       x = 'Country',
       y = 'Casualties')

cas_bar
ggplotly(cas_bar)



########################################################
# for iraq
# df8_1 = yr_70_91 %>% group_by(country_txt, iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
#                                                          wound = sum(nwound, na.rm = TRUE))
# df8_2 = yr_92_11 %>% group_by(country_txt, iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
#                                                          wound = sum(nwound, na.rm = TRUE))
# df8_3 = yr_93 %>% group_by(country_txt, iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
#                                                       wound = sum(nwound, na.rm = TRUE))
# df8_4 = yr_12_15 %>% group_by(country_txt, iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
#                                                          wound = sum(nwound, na.rm = TRUE))
# 
# most_casualties = rbind(df8_1,df8_2,df8_3,df8_4) %>% group_by(country_txt, iyear) %>% 
#   summarise(kills = round(sum(kills),0),
#             wound = round(sum(wound),0),
#             total_casualties = kills + wound) %>% filter(country_txt == 'Iraq')
# 
# cas_plot_iq =  ggplot(most_casualties, aes(iyear)) + theme_solarized_2() + 
#   scale_x_continuous(breaks = c(1970:2015)) +
#   geom_line(aes(y = kills, col = 'Kills'), size = 1.2) + 
#   geom_point(aes(y = kills), color = 'red')+
#   geom_line(aes(y = wound, col = 'Wound'), size = 1.2) + 
#   geom_point(aes(y = wound), color = 'blue') +
#   theme(axis.text.x = element_text(angle = 45, vjust = .6),
#         legend.title = element_blank()) +
#   labs(title = 'Evolution of Casualties in Iraq',
#        x = 'Year',
#        y = 'Casualties')
# 
# ggplotly(cas_plot_iq)
########################################################
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## QUESTION 9

df9_1 = yr_70_91 %>% group_by(iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))
df9_2 = yr_92_11 %>% group_by(iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))
df9_3 = yr_93 %>% group_by(iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                      wound = sum(nwound, na.rm = TRUE))
df9_4 = yr_12_15 %>% group_by(iyear) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))

casualties_by_yr = rbind(df9_1,df9_2,df9_3,df9_4) %>% group_by(iyear) %>% 
  summarise(kills = round(sum(kills),0),
            wound = round(sum(wound),0),
            total_casualties = kills + wound)


cas_plot =  ggplot(casualties_by_yr, aes(iyear)) + theme_solarized_2() + 
  scale_x_continuous(breaks = c(1970:2015)) +
  geom_line(aes(y = kills, col = 'Kills'), size = 1.2) + 
  geom_point(aes(y = kills), color = 'red')+
  geom_line(aes(y = wound, col = 'Wound'), size = 1.2) + 
  geom_point(aes(y = wound), color = 'blue') +
  theme(axis.text.x = element_text(angle = 45, vjust = .6),
        legend.title = element_blank()) +
  labs(title = 'Evolution of Casualties',
       x = 'Year',
       y = 'Casualties')

cas_plot
ggplotly(cas_plot)










#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# QUESTION 10

df10_1 = yr_70_91 %>% group_by(weaptype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))
df10_2 = yr_92_11 %>% group_by(weaptype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))
df10_3 = yr_93 %>% group_by(weaptype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                      wound = sum(nwound, na.rm = TRUE))
df10_4 = yr_12_15 %>% group_by(weaptype1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))

casualties_by_weap = rbind(df10_1,df10_2,df10_3,df10_4) %>% group_by(weaptype1_txt) %>% 
  summarise(kills = round(sum(kills),0),
            wound = round(sum(wound),0),
            total_casualties = kills + wound)

weap_cas_plot =  plot_ly(casualties_by_weap, labels = ~weaptype1_txt, values = ~total_casualties, 
        type = 'pie', pull = .01, textposition = 'inside',
        textinfo = 'value+percent') %>%
  layout(title = 'CASUALTIES BY WEAPON TYPE.',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

weap_cas_plot

############################## 
# casualties_by_weap = casualties_by_weap[order(casualties_by_weap$total_casualties), ]
# casualties_by_weap$ymax = cumsum(casualties_by_weap$total_casualties)
# casualties_by_weap$ymin = c(0, head(casualties_by_weap$ymax, n=-1))
# 
# weap_cas_plot = ggplot(casualties_by_weap, aes(fill=weaptype1_txt, ymax=ymax, ymin=ymin, xmax=4, xmin=3)) +
#   geom_rect() +
#   theme_classic() +
#   coord_polar(theta="y") +
#   xlim(c(0, 4)) +
#   theme(panel.grid=element_blank()) +
#   theme(axis.text=element_blank()) +
#   theme(axis.ticks=element_blank()) +
#   annotate("text", x = 0, y = 0, label = "") +
#   labs(title="Casualties by weapon type.")
# 
# weap_cas_plot
# ggplotly(weap_cas_plot)
#####################################

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## QUESTION 11

df11_1 = yr_70_91 %>% group_by(natlty1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                            wound = sum(nwound, na.rm = TRUE))
df11_2 = yr_92_11 %>% group_by(natlty1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                            wound = sum(nwound, na.rm = TRUE))
df11_3 = yr_93 %>% group_by(natlty1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                         wound = sum(nwound, na.rm = TRUE))
df11_4 = yr_12_15 %>% group_by(natlty1_txt) %>% summarise(kills = sum(nkill, na.rm = TRUE),
                                                            wound = sum(nwound, na.rm = TRUE))

nationalities = rbind(df11_1,df11_2,df11_3,df11_4) %>% group_by(natlty1_txt) %>% 
  summarise(kills = round(sum(kills),0),
            wound = round(sum(wound),0),
            total_casualties = kills + wound) %>% arrange(-total_casualties)%>%
  head(10)

nl = gather(nationalities, cas_type, casualties, kills:wound)

natlt =  ggplot(nl, aes(fill=cas_type, y=casualties, x=reorder(natlty1_txt, -casualties))) +
  theme_fivethirtyeight() +
  geom_bar(position="dodge", stat="identity", width = .5) +
  theme(legend.title = element_blank(),
        legend.position = c(.9,.9)) +
  labs(title = 'Most targeted nationalities.',
       x = 'Nationalities',
       y = 'Casualties')

natlt
ggplotly(natlt)
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## QUESTION 12

# THEORY 1
df12_1 = yr_70_91 %>% group_by(country_txt) %>% summarise(failure = sum(success == 0, na.rm = TRUE),
                                                          tot = n(),
                                                          def_rate = failure/tot)
df12_2 = yr_92_11 %>% group_by(country_txt) %>%summarise(failure = sum(success == 0, na.rm = TRUE),
                                                         tot = n(),
                                                         def_rate = failure/tot)
df12_3 = yr_93 %>% group_by(country_txt) %>% summarise(failure = sum(success == 0, na.rm = TRUE),
                                                       tot = n(),
                                                       def_rate = failure/tot)
df12_4 = yr_12_15 %>% group_by(country_txt) %>%summarise(failure = sum(success == 0, na.rm = TRUE),
                                                         tot = n(),
                                                         def_rate = failure/tot)

# for more than 250 attacks
t1 = rbind(df12_1,df12_2,df12_3,df12_4) %>% group_by(country_txt) %>% 
  summarise(failure = sum(failure),
            total = sum(tot),
            def_rate = round(failure*100/total),0) %>% filter(total>250) %>% 
  arrange(-def_rate) %>% head(10)

str_def_t1 =  ggplot(t1, aes(x = reorder(country_txt, -def_rate), y = def_rate)) +
  geom_bar(stat = 'Identity', width = 0.5, aes(fill = country_txt)) +
  geom_text(aes(label = def_rate),
            position = position_dodge(width = 0.9),
            vjust = -0.2) +
  theme_economist() +
  theme(legend.title = element_blank(),
        legend.position = 'none')+
  labs(title = 'Countries with strong defence.',
       subtitle = 'For more than 250 attacks.',
       x = 'Country',
       y = 'Defence rate per 100 attacks')

str_def_t1


# for more than 1000 attacks

t2 = rbind(df12_1,df12_2,df12_3,df12_4) %>% group_by(country_txt) %>% 
  summarise(failure = sum(failure),
            total = sum(tot),
            def_rate = round(failure*100/total),0) %>% filter(total>1000) %>% 
  arrange(-def_rate) %>% head(10)

str_def_t2 =  ggplot(t2, aes(x = reorder(country_txt, -def_rate), y = def_rate)) +
  geom_bar(stat = 'Identity', width = 0.5, aes(fill = country_txt)) +
  geom_text(aes(label = def_rate),
            position = position_dodge(width = 0.9),
            vjust = -0.2) +
  theme_economist() +
  theme(legend.title = element_blank(),
        legend.position = 'none')+
  labs(title = 'Countries with strong defence.',
       subtitle = 'For more than 1000 attacks.',
       x = 'Country',
       y = 'Defence rate per 100 attacks')

str_def_t2

#THEORY 2























