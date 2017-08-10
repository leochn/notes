---
title: mysql分组查询最新的插入数据
date: 2017-08-10 13:45:31
tags: mysql
---
## 使用场景
现场的A设备有100个采集点，但是这100个采集点的采集频率是不同的，这些采集的数据都会实时传输到mysql数据库。需求是:查询出A设备这100个采集点的最新数据。

## 模拟真实数据
### 数据库表
```sql
DROP TABLE IF EXISTS `service_values_today`;
CREATE TABLE `service_values_today` (
  `ID_DEVICE` varchar(50) NOT NULL,
  `ID_SERVICE` varchar(50) NOT NULL,
  `TAG_NAME` varchar(100) NOT NULL,
  `DATE_TIME` datetime NOT NULL,
  `PV` float DEFAULT NULL,
  `EU` varchar(20) DEFAULT NULL,
  UNIQUE KEY `ux_service_value_ixtd` (`ID_SERVICE`,`DATE_TIME`) USING BTREE,
  KEY `inx_service_value_tmtd` (`DATE_TIME`),
  KEY `inx_service_value_id_devicetd` (`ID_DEVICE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='当日实时表';
```

### 插入数据

```sql
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:24', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:23', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\PureWaterTankLevel', '净水箱液位', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\DrainageLevel', '集水井液位', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2Tanklevel', '2#水箱液位', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1Tanklevel', '1#水箱液位', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\Tanklevel', '水箱液位', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6RunningTime', '6#泵运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3RunningTime', '3#泵运行时间', '2017-08-10 13:47:22', '403', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2RunningTime', '2#泵运行时间', '2017-08-10 13:47:22', '32', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1RunningTime', '1#泵运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OutletRange', '出口量程（MPa）', '2017-08-10 13:47:22', '32', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletRange', '进口量程（MPa）', '2017-08-10 13:47:22', '12', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2PumpRun', '2#水泵运行', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1PumpStop', '1#水泵停止', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1PumpRun', '1#水泵运行', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8AutomaticMode', '8#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7AutomaticMode', '7#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6AutomaticMode', '6#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5AutomaticMode', '5#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4AutomaticMode', '4#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3AutomaticMode', '3#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2AutomaticMode', '2#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1AutomaticMode', '1#自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8ManualMode', '8#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7ManualMode', '7#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6ManualMode', '6#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5ManualMode', '5#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4ManualMode', '4#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3ManualMode', '3#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2ManualMode', '2#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1ManualMode', '1#手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ManualMode', '手动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\AutomaticMode', '自动模式', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ProductionPressure', '产水压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ConcentrateWaterOutletPressure', '浓水出口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BoosterPumpInletPressure', '增压泵进口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\PretreatmentPressure', '预处理出口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OriginalPumpOutletPressure', '原水泵出口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\SuperhighCavityPressure', '超高压腔压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\HighCavityPressure', '高压腔压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BoosterPumpOutletPressure', '增压泵出口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OutletPressure', '出口压力', '2017-08-10 13:47:22', '20', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BackFlow', '回水流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ProductionFlow', '产水流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8CumulativeFlow', '8#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7CumulativeFlow', '7#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6CumulativeFlow', '6#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5CumulativeFlow', '5#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4CumulativeFlow', '4#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3CumulativeFlow', '3#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2CumulativeFlow', '2#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1CumulativeFlow', '1#累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8InstantaneousFlow', '8#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7InstantaneousFlow', '7#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6InstantaneousFlow', '6#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5InstantaneousFlow', '5#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4InstantaneousFlow', '4#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3InstantaneousFlow', '3#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2InstantaneousFlow', '2#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1InstantaneousFlow', '1#瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\CumulativeFlow', '累计流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InstantaneousFlow', '瞬时流量', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyTotalKWH', '8#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyRunningTime', '8#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyPower', '8#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyOutputVoltage', '8#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyTemp', '8#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencySpeed', '8#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyOutput', '8#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyCurrent', '8#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyTotalKWH', '7#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyRunningTime', '7#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyPower', '7#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyOutputVoltage', '7#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyTemp', '7#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencySpeed', '7#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyOutput', '7#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7FrequencyCurrent', '7#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyTotalKWH', '6#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyRunningTime', '6#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyPower', '6#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyOutputVoltage', '6#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyTemp', '6#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencySpeed', '6#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyOutput', '6#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6FrequencyCurrent', '6#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyTotalKWH', '5#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyRunningTime', '5#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyPower', '5#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyOutputVoltage', '5#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyTemp', '5#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencySpeed', '5#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyOutput', '5#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5FrequencyCurrent', '5#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyTotalKWH', '4#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyRunningTime', '4#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyPower', '4#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyOutputVoltage', '4#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyTemp', '4#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencySpeed', '4#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyOutput', '4#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4FrequencyCurrent', '4#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyTotalKWH', '3#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyRunningTime', '3#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyPower', '3#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyOutputVoltage', '3#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyTemp', '3#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencySpeed', '3#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyOutput', '3#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3FrequencyCurrent', '3#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyTotalKWH', '2#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyRunningTime', '2#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyPower', '2#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyOutputVoltage', '2#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyTemp', '2#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencySpeed', '2#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyOutput', '2#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2FrequencyCurrent', '2#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyTotalKWH', '1#变频器累计功耗', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyRunningTime', '1#变频器运行时间', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyPower', '1#电机功率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyOutputVoltage', '1#输出电压', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyTemp', '1#变频温度', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencySpeed', '1#电机转速', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyOutput', '1#变频频率', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1FrequencyCurrent', '1#变频电流', '2017-08-10 13:47:22', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:21', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:20', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:19', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:18', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:17', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:16', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:15', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:14', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:13', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\PureWaterTankLevel', '净水箱液位', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\DrainageLevel', '集水井液位', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2Tanklevel', '2#水箱液位', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1Tanklevel', '1#水箱液位', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\Tanklevel', '水箱液位', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6RunningTime', '6#泵运行时间', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3RunningTime', '3#泵运行时间', '2017-08-10 13:47:12', '393', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2RunningTime', '2#泵运行时间', '2017-08-10 13:47:12', '32', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1RunningTime', '1#泵运行时间', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OutletRange', '出口量程（MPa）', '2017-08-10 13:47:12', '32', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletRange', '进口量程（MPa）', '2017-08-10 13:47:12', '12', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2PumpRun', '2#水泵运行', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1PumpStop', '1#水泵停止', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1PumpRun', '1#水泵运行', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8AutomaticMode', '8#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7AutomaticMode', '7#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6AutomaticMode', '6#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5AutomaticMode', '5#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4AutomaticMode', '4#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3AutomaticMode', '3#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2AutomaticMode', '2#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1AutomaticMode', '1#自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8ManualMode', '8#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7ManualMode', '7#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6ManualMode', '6#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5ManualMode', '5#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4ManualMode', '4#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3ManualMode', '3#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2ManualMode', '2#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1ManualMode', '1#手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ManualMode', '手动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\AutomaticMode', '自动模式', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ProductionPressure', '产水压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ConcentrateWaterOutletPressure', '浓水出口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BoosterPumpInletPressure', '增压泵进口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\PretreatmentPressure', '预处理出口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OriginalPumpOutletPressure', '原水泵出口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\SuperhighCavityPressure', '超高压腔压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\HighCavityPressure', '高压腔压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BoosterPumpOutletPressure', '增压泵出口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\OutletPressure', '出口压力', '2017-08-10 13:47:12', '20', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InletPressure', '进口压力', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\BackFlow', '回水流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\ProductionFlow', '产水流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8CumulativeFlow', '8#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7CumulativeFlow', '7#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6CumulativeFlow', '6#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5CumulativeFlow', '5#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4CumulativeFlow', '4#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3CumulativeFlow', '3#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2CumulativeFlow', '2#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1CumulativeFlow', '1#累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8InstantaneousFlow', '8#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No7InstantaneousFlow', '7#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No6InstantaneousFlow', '6#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No5InstantaneousFlow', '5#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No4InstantaneousFlow', '4#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No3InstantaneousFlow', '3#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No2InstantaneousFlow', '2#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No1InstantaneousFlow', '1#瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\CumulativeFlow', '累计流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\InstantaneousFlow', '瞬时流量', '2017-08-10 13:47:12', '0', NULL);
INSERT INTO `service_values_today` (`ID_DEVICE`, `ID_SERVICE`, `TAG_NAME`, `DATE_TIME`, `PV`, `EU`) VALUES ('ooxxooxx', 'ooxxooxx\\No8FrequencyTotalKWH', '8#变频器累计功耗', '2017-08-10 13:47:12', '0', NULL);

```

## 实现查询
```sql
select * from (SELECT * from service_values_today where ID_DEVICE = 'ooxxooxx' ORDER BY DATE_TIME desc limit 500 ) tempData GROUP BY ID_SERVICE;
```

首先要对 DATE_TIME 进行降序排序(当然这里的 limit 500 可能会不精确。因为有可能在500条数据内全部都是采集频率快的数据)。
然后再根据这个结果集进行 GROUP BY 分组。

## 查询结果

查询前200条
```
SELECT * from service_values_today where ID_DEVICE = 'ooxxooxx' ORDER BY DATE_TIME desc limit 200;
```

![分组查询最新数据](/assets/images/mysql/mysql-分组查询最新数据01.png)

查询分组的最新数据
```sql
select * from (SELECT * from service_values_today where ID_DEVICE = 'ooxxooxx' ORDER BY DATE_TIME desc limit 500 ) tempData GROUP BY ID_SERVICE;
```

![分组查询最新数据](/assets/images/mysql/mysql-分组查询最新数据02.png)













