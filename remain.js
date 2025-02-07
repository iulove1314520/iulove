/**
 * 代理节点名称处理脚本
 * 功能：重命名、过滤、删除字段和排序
 * 版本要求：后端版本 > 2.14.88
 */
function operator(proxies, targetPlatform) {
  return proxies
    .map(proxy => {
      // 1. HOME 标记处理：精准匹配 "M1" 并重命名为 "HOME"
      proxy.name = proxy.name.replace(/(?<=\b|\s)M1(?=\b|\s)/g, 'HOME');
      
      // 2. 基础格式标准化处理
      proxy.name = proxy.name
        // 2.1 倍率格式标准化
        .replace(/\[Promotion.*?\]\s*x\s*(\d\.\d+)/i, '| $1x')      // 处理促销标记格式
        .replace(/(\d+\.\d)0+x/g, '$1x')                            // 删除倍率小数末尾的0
        .replace(/\[(\d+(\.\d+)?[Xx])\]/g, '| $1')                 // 统一倍率标记格式：[数字X] -> | 数字x
        .replace(/\[(Aliyun|UDPN)\s*(\d+[Xx])\]/g, '| $2')         // 处理供应商倍率格式
        .replace(/(?<!\S)\[Wcloud\](?!\S)/g, '| 2x')               // Wcloud特殊处理
        .replace(/\|\s*(\d+(?:\.\d+)?)[Xx]/gi, '| $1x')            // 统一倍率标记为小写x
        .replace(/(?<=\d)[Xx](?=\s|$)/g, 'x')                      // 将独立的X/x统一为小写
        
        // 2.2 数字格式标准化
        .replace(/([^\s\d.])(\d)/g, '$1 $2')                        // 数字前添加空格分隔（排除小数点）
        .replace(/(\d)\s+(?=\.|x)/g, '$1')                          // 删除数字和小数点/x之间的空格
        
        // 2.3 分隔符标准化
        .replace(/[\|｜]\s*/g, '| ')                                // 统一分隔符为英文|并保留一个空格
        .replace(/\s*\|\s*/g, ' | ')                               // 分隔符前后统一添加空格
        
        // 2.4 空格标准化
        .replace(/\s{2,}/g, ' ')                                   // 合并多余空格
        .trim();                                                   // 去除首尾空格
        
      // 3. 删除冗余信息
      proxy.name = proxy.name
        // 3.1 删除供应商标记
        .replace(/\b(Nerocloud|UDPN|HUAWEI|DMIT|Eons|Gcore|Jinx|Nearoute|Cloudflare|Misaka|Sakura|DigitalOcean|AWS|SG\.GS|Akile|Akari|PQS|Apol|Bangmod|Oracle|Linode|Gbnetwork|Webconex|Eastern|Aliyun|Google Cloud|Microsoft Azure|Vultr|OVH|Hetzner|Tencent Cloud|IDCloudhost|UpCloud|Scaleway|Rackspace|HostGator|GoDaddy|DreamHost|Fastly|Bluehost|InMotion|Kinsta|Namecheap|Hostinger|Amazon|EC2|Lightsail|ECS|GCP|Azure|Microsoft Cloud|AliCloud|Alibaba Cloud|QCloud|OCI|IBM Cloud)\b/gi, '')
        
        // 3.2 删除通用标记
        .replace(/\b(IEPL|IPLC|BGP|CN2|GT|GIA|AS\d+|PCW|UDP|TCP|QUIC|HTTP|WS|WSS|TLS|SSL|IPV4|IPV6|IEServer)\b/gi, '')
        .replace(/家宽|中继|专线|商宽|限速|不限速|直连|中转|隧道|核心|边缘|主力|备用|Base|Plus|Lite|Pro|Premium|Ultimate|Basic|Standard|Advanced|Enterprise|(?:临时|永久)节点|(?:临时|永久)维护|(?:临时|永久)下线|5M/gi, '')
        
        // 3.3 删除数据中心和服务商标记
        .replace(/\b(Equinix|Digital Realty|NTT|CyrusOne|CoreSite|QTS|Iron Mountain|Switch|GDS|SUNeVision|NextDC|Global Switch|ST Telemedia|Telehouse|@|Colo|DC)\b/gi, '')
        
        // 3.4 删除特殊标记
        .replace(/\(HW\)/gi, '')
        .replace(/[\[\]【】《》「」『』〈〉｛｝\(\)]/g, '')  // 删除各种括号
        
        // 3.5 删除特殊字符串
        .replace(/(乙酰氨基酚|次硝酸甘油|甲基苯丙酮|双氯芬酸钠|澳士蛋白酶|羟苯磺酸钠|氨基酮戊酸|盐酸氨溴索|磷酸肌酸钠|盐酸可待因|磺胺甲恶唑|尼达莫德酮)/g, '')
        

      // 4. 运营商标准化处理
      proxy.name = proxy.name
        // 4.1 主要运营商重命名为 HOME
        .replace(/\b(SONY|i-Cable|Comcast|Maxis|Sejong|NTT|CTM|HGC|Rakuten|HKT|HKBN|HiNet|Seednet|M1|CAT|Exetel|Biglobe|KDDI|SoNet|SoftBank|TM|KT|SK|LG)\b/gi, 'HOME')
        .replace(/\b(Bage|Frontier|Verizon|AT&T|ATT|T-Mobile|Videotron|SFR|Vodafone|Virgin|BT)\b/gi, 'HOME')
        
        // 4.2 中国运营商标准化
        .replace(/\b(中国电信|China Telecom|CT|ChinaTelecom|电信|CN-CT)\b/gi, '电信')
        .replace(/\b(中国联通|China Unicom|CU|ChinaUnicom|联通|CN-CU)\b/gi, '联通')
        .replace(/\b(中国移动|China Mobile|CM|ChinaMobile|移动|CN-CM)\b/gi, '移动')
        
        // 4.3 日本运营商标准化
        .replace(/\b(IIJ|Internet Initiative Japan)\b/gi, 'HOME')
        .replace(/\b(OCN|Open Computer Network)\b/gi, 'HOME')
        .replace(/\b(GMO|GMO Internet)\b/gi, 'HOME')
        
        // 4.4 韩国运营商标准化
        .replace(/\b(SKT|SK Telecom)\b/gi, 'HOME')
        .replace(/\b(KT Corporation|Korea Telecom)\b/gi, 'HOME')
        .replace(/\b(LG U\+|LG Uplus|LGU\+)\b/gi, 'HOME')
        
        // 4.5 美国运营商标准化
        .replace(/\b(Sprint|T-Mobile US|US Cellular|Cox|Charter|Spectrum|Xfinity)\b/gi, 'HOME')
        .replace(/\b(CenturyLink|Level ?3|Lumen)\b/gi, 'HOME')
        .replace(/\b(AT&T Business|AT&T Mobility|AT&T Internet)\b/gi, 'HOME')
        
        // 4.6 欧洲运营商标准化
        .replace(/\b(Deutsche Telekom|Telekom Deutschland|O2 Germany)\b/gi, 'HOME')
        .replace(/\b(Orange|Bouygues|Free Mobile|Iliad)\b/gi, 'HOME')
        .replace(/\b(TIM|Telecom Italia|Wind Tre|Fastweb)\b/gi, 'HOME')
        .replace(/\b(Telefonica|Movistar|Vodafone ES|Orange ES)\b/gi, 'HOME')
        
        // 4.7 澳洲和新西兰运营商标准化
        .replace(/\b(Telstra|Optus|TPG|Vodafone AU|Aussie Broadband)\b/gi, 'HOME')
        .replace(/\b(Spark NZ|Vodafone NZ|2degrees|Vocus NZ)\b/gi, 'HOME')
        
        // 4.8 东南亚运营商标准化
        .replace(/\b(Singtel|StarHub|M1 Limited|MyRepublic SG)\b/gi, 'HOME')
        .replace(/\b(PLDT|Globe Telecom|Dito|Converge ICT)\b/gi, 'HOME')
        .replace(/\b(True|AIS|DTAC|3BB|TOT)\b/gi, 'HOME')
        
        // 4.9 其他特殊运营商处理
        .replace(/\b(AWS Direct Connect|Azure ExpressRoute|GCP Cloud Interconnect)\b/gi, 'HOME')
        .replace(/\b(Equinix|Digital Realty|NTT Communications)\b/gi, 'HOME')
        .replace(/\b(PCCW|HKIX|BBIX|JPIX|KINX)\b/gi, 'HOME')
        
        // 4.10 清理运营商相关标记
        .replace(/\s*[丨\-]\s*.*?(移动|联通|电信|双线|三线)(?=[^\u4e00-\u9fa5]|$)/g, '')  // 处理运营商标记
        .replace(/\s*-\s*L\s+(?:Haiko|Netease|Cloud)(?:\s+(?:移动|联通|电信))?\s+(?=x\s+\d)/gi, ' ')  // 处理特殊标识
        .replace(/(?:移动|联通|电信|双线|三线)(?=\s+(?:x|X)\s+\d|\s*$)/g, '')              // 处理末尾的运营商标记
        .replace(/(?:BGP|智能)(?:多线|专线|地区)?(?:接入|线路)?\s*/gi, '')                 // 移除BGP等标记
        .replace(/(?:电信|联通|移动|双线|三线)?(?:专线|精品|超级)(?:线路)?\s*/g, '')       // 移除线路类型标记
        .replace(/\s+(?:移动|联通|电信|双线|三线)(?:\s+|$)/g, ' ')                        // 清理剩余的运营商标记
        .replace(/\s+-\s*L\s+[A-Za-z]+(?:\s+[A-Za-z]+)*\s+(?=x\s+\d)/gi, ' ');           // 处理其他可能的特殊标识

      // 5. 区域名称标准化
      proxy.name = proxy.name
        // 5.1 特殊区域名称、别名处理
        .replace(/狮城/g, '新加坡')                                          
        .replace(/\[home\]/gi, '丨HOME 2x')
        .replace(/\s*丨.*?(移动|联通|电信|双线|三线)(?=[^\u4e00-\u9fa5]|$)/g, '')  // 移除运营商标记

        // 5.2 主要地区标准化 (使用 \b 进行单词边界匹配，避免部分匹配)
        .replace(/\b(HK|Hong Kong|H\.K\.|港)\b/gi, '香港')
        .replace(/\b(MO|Macao|Macau|Mac\.?)\b/gi, '澳门') // 添加 Mac. 和 Mac
        .replace(/\b(TW|Taiwan|Tai Wan|T\.W\.)\b/gi, '台湾') // 添加 Tai Wan 和 T.W.
        .replace(/\b(JP|Japan|JPN|J\.P\.)\b/gi, '日本')    // 添加 JPN 和 J.P.
        .replace(/\b(KR|South Korea|Korea|K\.?R\.?|ROK)\b/gi, '韩国') // 添加 K.R. 和 ROK, 以及 K.R.
        .replace(/\b(SG|Singapore|Sing\.?|S\.G\.)\b/gi, '新加坡')  // 添加 Sing. 和 S.G.
        .replace(/\b(US|USA|United States|America|U\.S\.A?\.?)\b/gi, '美国') // 添加 U.S.A 和 U.S.A.
        .replace(/\b(UK|GB|United Kingdom|Britain|England|U\.K\.)\b/gi, '英国') // 添加 U.K.

        // 5.3 欧洲地区标准化
        .replace(/\b(FR|France|FRA|F\.R\.)\b/gi, '法国')
        .replace(/\b(DE|Germany|Deutschland|GER|D\.E\.)\b/gi, '德国') // 添加 Deutschland 和 GER, D.E.
        .replace(/\b(IT|Italy|Italia|ITA|I\.T\.)\b/gi, '意大利')  // 添加 ITA 和 I.T.
        .replace(/\b(ES|Spain|España|ESP|E\.S\.)\b/gi, '西班牙')  // 添加 España, ESP 和 E.S.
        .replace(/\b(PT|Portugal|PRT|P\.T\.)\b/gi, '葡萄牙') // 添加 PRT 和 P.T.
        .replace(/\b(NL|Netherlands|Holland|NLD|N\.L\.)\b/gi, '荷兰') // 添加 Holland, NLD, N.L.
        .replace(/\b(BE|Belgium|BEL|B\.E\.)\b/gi, '比利时')   // 添加 BEL 和 B.E.
        .replace(/\b(SE|Sweden|SWE|S\.E\.)\b/gi, '瑞典') // 添加 SWE 和 S.E.
        .replace(/\b(NO|Norway|NOR|N\.O\.)\b/gi, '挪威')  // 添加 NOR 和 N.O.
        .replace(/\b(FI|Finland|FIN|F\.I\.)\b/gi, '芬兰') // 添加 FIN 和 F.I.
        .replace(/\b(DK|Denmark|DNK|D\.K\.)\b/gi, '丹麦')  // 添加 DNK, D.K.
        .replace(/\b(IE|Ireland|IRL|I\.E\.)\b/gi, '爱尔兰')  // 添加 IRL, I.E.

        // 5.4 亚洲地区标准化
        .replace(/\b(AU|Australia|AUS|A\.U\.)\b/gi, '澳大利亚') // 添加 AUS 和 A.U.
        .replace(/\b(NZ|New Zealand|NZL|N\.Z\.)\b/gi, '新西兰')  // 添加 NZL 和 N.Z.
        .replace(/\b(ID|Indonesia|IDN|I\.D\.)\b/gi, '印尼') // 添加 IDN 和 I.D.
        .replace(/\b(MY|Malaysia|MYS|M\.Y\.)\b/gi, '马来西亚') // 添加 MYS 和 M.Y.
        .replace(/\b(TH|Thailand|THA|T\.H\.)\b/gi, '泰国')   // 添加 THA 和 T.H.
        .replace(/\b(VN|Vietnam|VNM|V\.N\.)\b/gi, '越南') // 添加 VNM 和 V.N.
        .replace(/\b(PH|Philippines|PHL|P\.H\.)\b/gi, '菲律宾')  // 添加 PHL, P.H.
        .replace(/\b(IN|India|IND|I\.N\.)\b/gi, '印度') // 添加 IND, I.N.

        // 5.5 中东地区标准化
        .replace(/\b(AE|UAE|United Arab Emirates|U\.A\.E\.|Dubai|DXB)\b/gi, '阿联酋')
        .replace(/\b(IL|Israel|ISR|I\.L\.)\b/gi, '以色列')  // 添加 ISR 和 I.L.
        .replace(/\b(TR|Turkey|Türkiye|TUR|T\.R\.)\b/gi, '土耳其')  // 添加 TUR 和 T.R., Türkiye
        .replace(/\b(SA|Saudi Arabia|SAU|S\.A\.)\b/gi, '沙特')  // 添加 SAU 和 S.A.

        // 5.6 美洲地区标准化
        .replace(/\b(CA|Canada|CAN|C\.A\.)\b/gi, '加拿大')  // 添加 CAN 和 C.A.
        .replace(/\b(BR|Brazil|BRA|B\.R\.)\b/gi, '巴西')  // 添加 BRA 和 B.R.
        .replace(/\b(MX|Mexico|MEX|M\.X\.)\b/gi, '墨西哥') //添加 MEX 和 M.X.
        .replace(/\b(AR|Argentina|ARG|A\.R\.)\b/gi, '阿根廷') // 添加 ARG 和 A.R.

        // 5.7 其他地区及主要城市标准化 (将城市添加到对应国家)
        .replace(/\b(RU|Russia|RUS|Moscow|MOW)\b/gi, '俄罗斯')  // 添加 RUS, Moscow (莫斯科)
        .replace(/\b(ZA|South Africa|ZAF|Johannesburg|JNB)\b/gi, '南非') // 添加 ZAF, Johannesburg (约翰内斯堡)
        .replace(/\b(EG|Egypt|EGY|Cairo|CAI)\b/gi, '埃及')  // 添加 EGY, Cairo (开罗)
        .replace(/\b(Bangladesh|BD|BGD|Dhaka|DAC)\b/gi, '孟加拉') // 添加 BD, BGD, Dhaka (达卡)
        .replace(/\b(Switzerland|CH|CHE|Zurich|ZRH|Geneva|GVA)\b/gi, '瑞士') // 添加 CH, CHE, Zurich (苏黎世), Geneva (日内瓦)
        .replace(/\b(Austria|AT|AUT|Vienna|VIE)\b/gi, '奥地利') // 添加 AT, AUT, Vienna (维也纳)
        .replace(/\b(Iceland|IS|ISL|Reykjavik|KEF)\b/gi, '冰岛')  // 添加 IS, ISL, Reykjavik (雷克雅未克)
        .replace(/\b(Poland|PL|POL|Warsaw|WAW)\b/gi, '波兰')   // 添加 PL, POL, Warsaw (华沙)
        .replace(/\b(Angola|AO|AGO|Luanda|LAD)\b/gi, '安哥拉') // 添加 AO, AGO, Luanda (罗安达)
        .replace(/\b(Ukraine|UA|UKR|Kiev|KBP)\b/gi, '乌克兰') //添加 UA, UKR, Kiev(基辅)
        .replace(/\b(Cambodia|KH|KHM|Phnom Penh|PNH)\b/gi, '柬埔寨') //添加 KH, KHM, Phnom Penh(金边)
        .replace(/\b(Nepal|NP|NPL|Kathmandu|KTM)\b/gi, '尼泊尔')//添加 NP, NPL, Kathmandu(加德满都)
        .replace(/\b(Chile|CL|CHL|Santiago|SCL)\b/gi, '智利') //添加 CL, CHL, Santiago(圣地亚哥)
        .replace(/\b(Colombia|CO|COL|Bogota|BOG)\b/gi, '哥伦比亚')//添加 CO, COL, Bogota(波哥大)
        .replace(/\b(Peru|PE|PER|Lima|LIM)\b/gi, '秘鲁')//添加 PE, PER, Lima(利马)
        .replace(/\b(Bolivia|BO|BOL|La Paz|LPB)\b/gi, '玻利维亚') //添加 BO, BOL, La Paz(拉巴斯)
        .replace(/\b(Luxembourg|LU|LUX|Luxembourg City|LUX)\b/gi, '卢森堡') //添加 LU, LUX
        .replace(/\b(Estonia|EE|EST|Tallinn|TLL)\b/gi, '爱沙尼亚') // 添加 EE, EST, Tallinn(塔林)
        .replace(/\b(Hungary|HU|HUN|Budapest|BUD)\b/gi, '匈牙利') // 添加 HU, HUN, Budapest(布达佩斯)
        .replace(/\b(Moldova|MD|MDA|Chisinau|KIV)\b/gi, '摩尔多瓦') // 添加 MD, MDA, Chisinau(基希讷乌)
        .replace(/\b(Romania|RO|ROU|Bucharest|OTP)\b/gi, '罗马尼亚') // 添加 RO, ROU, Bucharest(布加勒斯特)
        .replace(/\b(Bulgaria|BG|BGR|Sofia|SOF)\b/gi, '保加利亚') // 添加 BG, BGR, Sofia(索菲亚)
        .replace(/\b(Serbia|RS|SRB|Belgrade|BEG)\b/gi, '塞尔维亚') // 添加 RS, SRB, Belgrade(贝尔格莱德)
        .replace(/\b(Greece|GR|GRC|Athens|ATH)\b/gi, '希腊') // 添加 GR, GRC, Athens(雅典)
        .replace(/\b(Iraq|IQ|IRQ|Baghdad|BGW)\b/gi, '伊拉克') // 添加 IQ, IRQ, Baghdad(巴格达)
        .replace(/\b(Togo|TG|TGO|Lome|LFW)\b/gi, '多哥') // 添加 TG, TGO, Lome(洛美)
        .replace(/\b(Tunisia|TN|TUN|Tunis|TUN)\b/gi, '突尼斯') // 添加 TN, TUN, Tunis (突尼斯市)
        .replace(/\b(Pakistan|PK|PAK|Islamabad|ISB|Karachi|KHI)\b/gi, '巴基斯坦') // 添加 PK, PAK, Islamabad(伊斯兰堡), Karachi(卡拉奇)
        .replace(/\b(Kazakhstan|KZ|KAZ|Astana|NQZ)\b/gi, '哈萨克斯坦') // 添加 KZ, KAZ, Astana(阿斯塔纳)
        .replace(/\b(Nigeria|NG|NGA|Lagos|LOS|Abuja|ABV)\b/gi, '尼日利亚') // 添加 NG, NGA, Lagos(拉各斯), Abuja(阿布贾)
        .replace(/\b(Antarctica|AQ|ATA)\b/gi, '南极洲') // 添加 AQ, ATA
        .replace(/\b(Croatia|HR|HRV|Zagreb|ZAG)\b/gi, '克罗地亚') // 添加 HR, HRV, Zagreb(萨格勒布)
        .replace(/\b(Czech Republic|Czech|Czechia|CZ|CZE|Prague|PRG|Brno|BRQ|Ostrava|OSR)\b/gi, '捷克') // 添加 CZ, CZE, Prague(布拉格), Brno(布尔诺), Ostrava(俄斯特拉发)
        .replace(/\b(Slovakia|SK|SVK|Bratislava|BTS)\b/gi, '斯洛伐克') // 添加 SK, SVK, Bratislava(布拉迪斯拉发)
        .replace(/\b(Slovenia|SI|SVN|Ljubljana|LJU)\b/gi, '斯洛文尼亚') // 添加 SI, SVN, Ljubljana(卢布尔雅那)
        .replace(/\b(Latvia|LV|LVA|Riga|RIX)\b/gi, '拉脱维亚') // 添加 LV, LVA, Riga(里加)
        .replace(/\b(Lithuania|LT|LTU|Vilnius|VNO)\b/gi, '立陶宛') // 添加 LT, LTU, Vilnius(维尔纽斯)
        .replace(/\b(Belarus|BY|BLR|Minsk|MSQ)\b/gi, '白俄罗斯') // 添加 BY, BLR, Minsk(明斯克)
        .replace(/\b(Malta|MT|MLT|Valletta|MLA)\b/gi, '马耳他') // 添加 MT, MLT, Valletta(瓦莱塔)
        .replace(/\b(Cyprus|CY|CYP|Nicosia|NIC)\b/gi, '塞浦路斯') // 添加 CY, CYP, Nicosia(尼科西亚)

        // 添加更多亚洲国家
        .replace(/\b(Laos|LA|LAO|Vientiane|VTE)\b/gi, '老挝') //添加 LA, LAO, Vientiane(万象)
        .replace(/\b(Myanmar|Burma|MM|MMR|Yangon|RGN)\b/gi, '缅甸') //添加 MM, MMR, Yangon(仰光)
        .replace(/\b(Brunei|BN|BRN|Bandar Seri Begawan|BWN)\b/gi, '文莱')//添加 BN, BRN, Bandar Seri Begawan (斯里巴加湾)
        .replace(/\b(Mongolia|MN|MNG|Ulaanbaatar|ULN)\b/gi, '蒙古') //添加 MN, MNG, Ulaanbaatar (乌兰巴托)
        .replace(/\b(Bhutan|BT|BTN|Thimphu|PBH)\b/gi, '不丹') //添加 BT, BTN, Thimphu(廷布)
        .replace(/\b(Sri Lanka|LK|LKA|Colombo|CMB)\b/gi, '斯里兰卡')//添加 LK, LKA, Colombo(科伦坡)
        .replace(/\b(Maldives|MV|MDV|Male|MLE)\b/gi, '马尔代夫') //添加 MV, MDV, Male(马累)
        .replace(/\b(Azerbaijan|AZ|AZE|Baku|GYD)\b/gi, '阿塞拜疆') // 添加 AZ, AZE, Baku (巴库)
        .replace(/\b(Uzbekistan|UZ|UZB|Tashkent|TAS)\b/gi, '乌兹别克斯坦') //添加 UZ, UZB, Tashkent (塔什干)
        
        // 添加更多中东国家

        .replace(/\b(Kuwait|KW|KWT|Kuwait City|KWI)\b/gi, '科威特')//添加 KW, KWT
        .replace(/\b(Bahrain|BH|BHR|Manama|BAH)\b/gi, '巴林')//添加 BH, BHR, Manama(麦纳麦)
        .replace(/\b(Qatar|QA|QAT|Doha|DOH)\b/gi, '卡塔尔')//添加 QA, QAT, Doha(多哈)
        .replace(/\b(Oman|OM|OMN|Muscat|MCT)\b/gi, '阿曼') //添加 OM, OMN, Muscat(马斯喀特)
        .replace(/\b(Yemen|YE|YEM|Sanaa|SAH)\b/gi, '也门')//添加 YE, YEM, Sanaa(萨那)
        .replace(/\b(Jordan|JO|JOR|Amman|AMM)\b/gi, '约旦') //添加 JO, JOR, Amman(安曼)
        .replace(/\b(Lebanon|LB|LBN|Beirut|BEY)\b/gi, '黎巴嫩')//添加 LB, LBN, Beirut(贝鲁特)

        // 添加更多非洲国家
        .replace(/\b(Morocco|MA|MAR|Rabat|RBA)\b/gi, '摩洛哥')//添加 MA, MAR, Rabat(拉巴特)
        .replace(/\b(Algeria|DZ|DZA|Algiers|ALG)\b/gi, '阿尔及利亚')//添加 DZ, DZA, Algiers(阿尔及尔)
        .replace(/\b(Libya|LY|LBY|Tripoli|TIP)\b/gi, '利比亚') //添加 LY, LBY, Tripoli(的黎波里)
        .replace(/\b(Sudan|SD|SDN|Khartoum|KRT)\b/gi, '苏丹') //添加 SD, SDN, Khartoum(喀土穆)
        .replace(/\b(Ethiopia|ET|ETH|Addis Ababa|ADD)\b/gi, '埃塞俄比亚')//添加 ET, ETH, Addis Ababa(亚的斯亚贝巴)
        .replace(/\b(Kenya|KE|KEN|Nairobi|NBO)\b/gi, '肯尼亚')//添加 KE, KEN, Nairobi(内罗毕)
        .replace(/\b(Tanzania|TZ|TZA|Dodoma|DOD)\b/gi, '坦桑尼亚') //添加 TZ, TZA, Dodoma(多多马)
        .replace(/\b(Uganda|UG|UGA|Kampala|EBB)\b/gi, '乌干达') //添加 UG, UGA, Kampala(坎帕拉)
        .replace(/\b(Ghana|GH|GHA|Accra|ACC)\b/gi, '加纳')//添加 GH, GHA, Accra(阿克拉)

        // 添加更多美洲国家
        .replace(/\b(Venezuela|VE|VEN|Caracas|CCS)\b/gi, '委内瑞拉')//添加 VE, VEN, Caracas(加拉加斯)
        .replace(/\b(Ecuador|EC|ECU|Quito|UIO)\b/gi, '厄瓜多尔')//添加 EC, ECU, Quito(基多)
        .replace(/\b(Paraguay|PY|PRY|Asuncion|ASU)\b/gi, '巴拉圭') //添加 PY, PRY, Asuncion(亚松森)
        .replace(/\b(Uruguay|UY|URY|Montevideo|MVD)\b/gi, '乌拉圭')//添加 UY, URY, Montevideo(蒙得维的亚)
        .replace(/\b(Panama|PA|PAN|Panama City|PTY)\b/gi, '巴拿马')//添加 PA, PAN
        .replace(/\b(Costa Rica|CR|CRI|San Jose|SJO)\b/gi, '哥斯达黎加')//添加 CR, CRI, San Jose(圣何塞)
        .replace(/\b(Jamaica|JM|JAM|Kingston|KIN)\b/gi, '牙买加')//添加 JM, JAM, Kingston(金斯敦)

      // 6. 标签格式标准化处理（新增）
      proxy.name = proxy.name
        .replace(/([\u4e00-\u9fa5]+)\s*\[(Pre|Lite|Std|Ultra)\]\s*(\d+x)/gi, '$1 $2 | $3');

      // 7. 低倍率节点处理
      proxy.name = proxy.name
        .replace(/^([⏬]?[\u4e00-\u9fa5]+)\s*低倍率.*/, '$1 | 0.2x');

      // 8. 倍率标准化处理
      proxy.name = proxy.name
        .replace(/\[([^\]]+)\]\s*1x/gi, '[$1] 2x')
        .replace(/(香港|新加坡|美国|日本|台湾)\s*实验性\s*1\b/g, '$1 实验性')
        .replace(/(香港|新加坡|美国|日本|台湾|韩国|马来西亚|英国|德国|法国|摩尔多瓦|乌克兰|意大利|匈牙利|西班牙|土耳其|荷兰|加拿大|阿根廷|巴西|智利|澳大利亚|新西兰|印尼|泰国|越南|印度|巴基斯坦|以色列|阿联酋|菲律宾|埃及)\s*(高级|标准)\s*(\d+)\b/g, '$1 $2 $3')
        .replace(/([^\s])HOME\b/g, '$1 HOME');

      // 9. 过滤无效节点
      const filterPattern = /(?:\W|^)(订阅|套餐|到期|有效|剩余|版本|已用|过期|失联|测试|官方|网址|备用|群|TEST|客服|网站|获取|流量|机场|下次|官|系|邮箱|工单|学术|USE|USED|TOTAL|EXPIRE|EMAIL|Traffic)(?:\W|$)/i;
      if (filterPattern.test(proxy.name)) return null;

      return proxy;
    })
    .filter(proxy => proxy !== null)
    .sort((a, b) => {
      // 10. 节点排序优先级处理
      for (let pattern of sortPatterns) {
        const aMatch = pattern.test(a.name);
        const bMatch = pattern.test(b.name);
        
        // 如果两个节点都匹配或都不匹配当前规则,继续检查下一个规则
        if (aMatch === bMatch) continue;
        
        // 匹配规则的节点优先
        return aMatch ? -1 : 1;
      }
      
      // 如果没有匹配任何规则,按照节点名称字母顺序排序
      const aName = a.name.toLowerCase();
      const bName = b.name.toLowerCase();
      
      // 处理中文排序
      if (aName.match(/[\u4e00-\u9fa5]/) && bName.match(/[\u4e00-\u9fa5]/)) {
        return aName.localeCompare(bName, 'zh-CN');
      }
      
      // 处理英文和其他字符排序
      return aName.localeCompare(bName, 'en');
    });
}

// 排序优先级定义
const sortPatterns = [
  // 1. 特殊类型节点优先级
  /活动/i,                                      // 1.1 活动节点最优先
  /直连/i,                                      // 1.2 直连节点次优先
  
  // 2. 倍率优先级 (从低到高)
  /\|\s*0\.1x/i,                               // 2.1 0.1倍率节点
  /\|\s*0\.2x/i,                               // 2.2 0.2倍率节点
  /\|\s*0\.3x/i,                               // 2.3 0.3倍率节点
  /\|\s*0\.4x/i,                               // 2.4 0.4倍率节点
  /\|\s*0\.5x/i,                               // 2.5 0.5倍率节点
  /\|\s*0\.6x/i,                               // 2.6 0.6倍率节点
  /\|\s*0\.7x/i,                               // 2.7 0.7倍率节点
  /\|\s*0\.8x/i,                               // 2.8 0.8倍率节点
  /\|\s*0\.9x/i,                               // 2.9 0.9倍率节点
  /\|\s*0\.\s*[123456789]X/i,                  // 2.10 低倍率通用匹配
  /(?:x|X)\s*0\.[123456789]\d*/i,              // 2.11 x 0.xx格式的低倍率
  /\s+x\s+0\.[123456789]\d*/i,                 // 2.12 空格x空格0.xx格式的低倍率
  /低倍率/i,                                    // 2.13 低倍率标记
  /0\.\d+\s*[xX]/i,                           // 2.14 小数倍率
  /实验性/i,                                    // 2.15 实验性节点
  
  // 3. 游戏节点优先级
  /Game|游戏/i,                                 // 3.1 游戏节点
  
  // 4. 主要地区优先级
  /香港|HK|Hong Kong|港/i,                      // 4.1 香港节点
  /台湾|TW|Taiwan|台/i,                         // 4.2 台湾节点
  /日本|JP|Tokyo|Osaka|Japan|日(?!利亚)/i,      // 4.3 日本节点
  /新加坡|SG|Singapore|新(?!西兰)/i,            // 4.4 新加坡节点
  /美国|US|United States|LA|Los Angeles|New York|San Francisco|美/i,  // 4.5 美国节点
  
  // 5. 次要地区优先级
  /韩国|KR|South Korea|首尔/i,                  // 5.1 韩国节点
  /马来西亚|MY|Malaysia|大马/i,                 // 5.2 马来西亚节点
  /英国|UK|United Kingdom|伦敦/i,               // 5.3 英国节点
  /德国|DE|Germany|柏林/i,                      // 5.4 德国节点
  /法国|FR|France|巴黎/i                        // 5.5 法国节点
];
  
