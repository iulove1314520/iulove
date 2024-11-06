// Regex Rename, Filter, Delete Field, and Sort Operator with Specific Formatting
// 1. backend version(>2.14.88):
function operator(proxies, targetPlatform) {
  return proxies
    .map(proxy => {
      // 精准匹配 "M1" 并重命名为 "HOME"
      proxy.name = proxy.name.replace(/(?<=\b|\s)M1(?=\b|\s)/g, 'HOME');
      
      // 先进行原有的重命名操作
      proxy.name = proxy.name
        .replace(/\[(\d+(\.\d+)?[Xx])\]/g, '| $1')                  // 将 [数字X] 或 [数字x] 格式替换为 | 数字x
        .replace(/\[(Aliyun|UDPN)\s*(\d+[Xx])\]/g, '| $2')           // 将 [Aliyun或UDPN 数字X或数字x] 格式替换为 | 数字x
        .replace(/([^\s\d])(\d)/g, '$1 $2')                          // 匹配非空格数字，添加空格分隔
        .replace(/(?<!\S)\[Wcloud\](?!\S)/g, '| 2x')                 // 匹配 [Wcloud] 替换为 | 2x
        .replace(/\s{2,}/g, ' ')                                     // 移除多余空格
        .replace(/X/g, 'x')                                          // 将结果中的所有 X 替换为 x
        .trim();
      
        
      // 删除名称中符合条件的字段
        proxy.name = proxy.name.replace(/\b(DMIT|Eons|Gcore|Jinx|Nearoute|Cloudflare|Misaka|Sakura|DigitalOcean|AWS|SG\.GS|Akile|Akari|PQS|Apol|Bangmod|Oracle|Linode|Gbnetwork|Webconex|Eastern|Aliyun|Google Cloud|Microsoft Azure|Vultr|OVH|Hetzner|Tencent Cloud|IDCloudhost|UpCloud|Scaleway|Rackspace|HostGator|GoDaddy|DreamHost|Fastly|Bluehost|InMotion|Kinsta|Namecheap|Hostinger)\b/gi, '');
        proxy.name = proxy.name.replace(/家宽|IEPL|中继|Base|Plus|限速|5M/gi, '');
        proxy.name = proxy.name.replace(/\(HW\)/gi, '');
        
      // 再进行新的正则重命名操作
      proxy.name = proxy.name
        .replace(/\b(Rakuten|HKT|HKBN|HiNet|Seednet|M1|CAT|Exetel|Biglobe|KDDI|SoNet|SoftBank|TM|KT|SK|LG)\b/gi, 'HOME')
        .replace(/\b(Frontier|Verizon|AT&T|ATT|T-Mobile|Videotron|SFR|Vodafone|Virgin|BT)\b/gi, 'HOME')
        .replace(/\b(SKT|CMCC|CUCC|CTCC|NTT|Singtel|Telstra|Optus|Telkom|PLDT|AIS|Maxis|Globe|STC)\b/gi, 'HOME')
        .replace(/\b(TMNet|CTM|Etisalat|MTN|Orange|TIM|Telefónica|Deutsche Telekom|Bell|Rogers|Telus)\b/gi, 'HOME')
        .replace(/\b(China Mobile|China Unicom|China Telecom|Nippon Telegraph and Telephone|Saudi Telecom Company)\b/gi, 'HOME')
        .replace(/\b(Advanced Info Service|MTN Group|Telecom Italia|Philippine Long Distance Telephone)\b/gi, 'HOME')
        .replace(/\b(British Telecommunications|Emirates Telecommunications Corporation|Orange SA|Telefónica SA)\b/gi, 'HOME')
        .replace(/\b(Vodafone Group|Bell Canada|Rogers Communications|Telus Corporation|Singapore Telecommunications)\b/gi, 'HOME')
        .replace(/\b(Korea Telecom|SK Telecom|LG U\+|T-Mobile US|American Telephone and Telegraph)\b/gi, 'HOME')
        .replace(/乐天移动/g, 'HOME')
        .replace(/狮城/g, '新加坡')                                          
        .replace(/\[home\]/gi, '丨HOME 2x')
        .replace(/\b(HK|Hong Kong)\b/g, '香港')
        .replace(/\b(MO|Macao|Macau)\b/g, '澳门')
        .replace(/\b(TW|Taiwan)\b/g, '台湾')
        .replace(/\b(JP|Japan)\b/g, '日本')
        .replace(/\b(KR|South Korea|Korea)\b/g, '韩国')
        .replace(/\b(SG|Singapore)\b/g, '新加坡')
        .replace(/\b(US|USA|United States|America)\b/g, '美国')
        .replace(/\b(UK|GB|United Kingdom|Britain|England)\b/g, '英国')
        .replace(/\b(FR|France)\b/g, '法国')
        .replace(/\b(DE|Germany)\b/g, '德国')
        .replace(/\b(AU|Australia)\b/g, '澳大利亚')
        .replace(/\b(AE|UAE|United Arab Emirates|Emirates)\b/g, '阿联酋')
        .replace(/\b(AF|Afghanistan)\b/g, '阿富汗')
        .replace(/\b(AL|Albania)\b/g, '阿尔巴尼亚')
        .replace(/\b(DZ|Algeria)\b/g, '阿尔及利亚')
        .replace(/\b(AO|Angola)\b/g, '安哥拉')
        .replace(/\b(AR|Argentina)\b/g, '阿根廷')
        .replace(/\b(AM|Armenia)\b/g, '亚美尼亚')
        .replace(/\b(AT|Austria)\b/g, '奥地利')
        .replace(/\b(AZ|Azerbaijan)\b/g, '阿塞拜疆')
        .replace(/\b(BH|Bahrain)\b/g, '巴林')
        .replace(/\b(BD|Bangladesh)\b/g, '孟加拉国')
        .replace(/\b(BY|Belarus)\b/g, '白俄罗斯')
        .replace(/\b(BE|Belgium)\b/g, '比利时')
        .replace(/\b(BZ|Belize)\b/g, '伯利兹')
        .replace(/\b(BJ|Benin)\b/g, '贝宁')
        .replace(/\b(BT|Bhutan)\b/g, '不丹')
        .replace(/\b(BO|Bolivia)\b/g, '玻利维亚')
        .replace(/\b(BA|Bosnia and Herzegovina)\b/g, '波斯尼亚和黑塞哥维那')
        .replace(/\b(BW|Botswana)\b/g, '博茨瓦纳')
        .replace(/\b(BR|Brazil)\b/g, '巴西')
        .replace(/\b(VG|British Virgin Islands)\b/g, '英属维京群岛')
        .replace(/\b(BN|Brunei)\b/g, '文莱')
        .replace(/\b(BG|Bulgaria)\b/g, '保加利亚')
        .replace(/\b(BF|Burkina Faso)\b/g, '布基纳法索')
        .replace(/\b(BI|Burundi)\b/g, '布隆迪')
        .replace(/\b(KH|Cambodia)\b/g, '柬埔寨')
        .replace(/\b(CM|Cameroon)\b/g, '喀麦隆')
        .replace(/\b(CA|Canada)\b/g, '加拿大')
        .replace(/\b(CV|Cape Verde)\b/g, '佛得角')
        .replace(/\b(KY|Cayman Islands)\b/g, '开曼群岛')
        .replace(/\b(CF|Central African Republic)\b/g, '中非共和国')
        .replace(/\b(TD|Chad)\b/g, '乍得')
        .replace(/\b(CL|Chile)\b/g, '智利')
        .replace(/\b(CO|Colombia)\b/g, '哥伦比亚')
        .replace(/\b(KM|Comoros)\b/g, '科摩罗')
        .replace(/\b(CG|Congo)\b/g, '刚果(布)')
        .replace(/\b(CD|Democratic Republic of the Congo)\b/g, '刚果(金)')
        .replace(/\b(CR|Costa Rica)\b/g, '哥斯达黎加')
        .replace(/\b(HR|Croatia)\b/g, '克罗地亚')
        .replace(/\b(CY|Cyprus)\b/g, '塞浦路斯')
        .replace(/\b(CZ|Czech|Czech Republic)\b/g, '捷克')
        .replace(/\b(DK|Denmark)\b/g, '丹麦')
        .replace(/\b(DJ|Djibouti)\b/g, '吉布提')
        .replace(/\b(DO|Dominican Republic)\b/g, '多米尼加共和国')
        .replace(/\b(EC|Ecuador)\b/g, '厄瓜多尔')
        .replace(/\b(EG|Egypt)\b/g, '埃及')
        .replace(/\b(SV|El Salvador)\b/g, '萨尔瓦多')
        .replace(/\b(GQ|Equatorial Guinea)\b/g, '赤道几内亚')
        .replace(/\b(ER|Eritrea)\b/g, '厄立特里亚')
        .replace(/\b(EE|Estonia)\b/g, '爱沙尼亚')
        .replace(/\b(ET|Ethiopia)\b/g, '埃塞俄比亚')
        .replace(/\b(FJ|Fiji)\b/g, '斐济')
        .replace(/\b(FI|Finland)\b/g, '芬兰')
        .replace(/\b(GA|Gabon)\b/g, '加蓬')
        .replace(/\b(GM|Gambia)\b/g, '冈比亚')
        .replace(/\b(GE|Georgia)\b/g, '格鲁吉亚')
        .replace(/\b(GH|Ghana)\b/g, '加纳')
        .replace(/\b(GR|Greece)\b/g, '希腊')
        .replace(/\b(GL|Greenland)\b/g, '格陵兰')
        .replace(/\b(GT|Guatemala)\b/g, '危地马拉')
        .replace(/\b(GN|Guinea)\b/g, '几内亚')
        .replace(/\b(GY|Guyana)\b/g, '圭亚那')
        .replace(/\b(HT|Haiti)\b/g, '海地')
        .replace(/\b(HN|Honduras)\b/g, '洪都拉斯')
        .replace(/\b(HU|Hungary)\b/g, '匈牙利')
        .replace(/\b(IS|Iceland)\b/g, '冰岛')
        .replace(/\b(IN|India)\b/g, '印度')
        .replace(/\b(ID|Indonesia)\b/g, '印尼')
        .replace(/\b(IR|Iran)\b/g, '伊朗')
        .replace(/\b(IQ|Iraq)\b/g, '伊拉克')
        .replace(/\b(IE|Ireland)\b/g, '爱尔兰')
        .replace(/\b(IM|Isle of Man)\b/g, '马恩岛')
        .replace(/\b(IL|Israel)\b/g, '以色列')
        .replace(/\b(IT|Italy)\b/g, '意大利')
        .replace(/\b(CI|Ivory Coast|Côte d'Ivoire)\b/g, '科特迪瓦')
        .replace(/\b(JM|Jamaica)\b/g, '牙买加')
        .replace(/\b(JO|Jordan)\b/g, '约旦')
        .replace(/\b(KZ|Kazakhstan)\b/g, '哈萨克斯坦')
        .replace(/\b(KE|Kenya)\b/g, '肯尼亚')
        .replace(/\b(KW|Kuwait)\b/g, '科威特')
        .replace(/\b(KG|Kyrgyzstan)\b/g, '吉尔吉斯斯坦')
        .replace(/\b(LA|Laos)\b/g, '老挝')
        .replace(/\b(LV|Latvia)\b/g, '拉脱维亚')
        .replace(/\b(LB|Lebanon)\b/g, '黎巴嫩')
        .replace(/\b(LS|Lesotho)\b/g, '莱索托')
        .replace(/\b(LR|Liberia)\b/g, '利比里亚')
        .replace(/\b(LY|Libya)\b/g, '利比亚')
        .replace(/\b(LT|Lithuania)\b/g, '立陶宛')
        .replace(/\b(LU|Luxembourg)\b/g, '卢森堡')
        .replace(/\b(MK|Macedonia)\b/g, '马其顿')
        .replace(/\b(MG|Madagascar)\b/g, '马达加斯加')
        .replace(/\b(MW|Malawi)\b/g, '马拉维')
        .replace(/\b(MY|Malaysia)\b/g, '马来西亚')
        .replace(/\b(MV|Maldives)\b/g, '马尔代夫')
        .replace(/\b(ML|Mali)\b/g, '马里')
        .replace(/\b(MT|Malta)\b/g, '马耳他')
        .replace(/\b(MR|Mauritania)\b/g, '毛利塔尼亚')
        .replace(/\b(MU|Mauritius)\b/g, '毛里求斯')
        .replace(/\b(MX|Mexico)\b/g, '墨西哥')
        .replace(/\b(MD|Moldova)\b/g, '摩尔多瓦')
        .replace(/\b(MC|Monaco)\b/g, '摩纳哥')
        .replace(/\b(MN|Mongolia)\b/g, '蒙古')
        .replace(/\b(ME|Montenegro)\b/g, '黑山共和国')
        .replace(/\b(MA|Morocco)\b/g, '摩洛哥')
        .replace(/\b(MZ|Mozambique)\b/g, '莫桑比克')
        .replace(/\b(MM|Myanmar)\b/g, '缅甸')
        .replace(/\b(NA|Namibia)\b/g, '纳米比亚')
        .replace(/\b(NP|Nepal)\b/g, '尼泊尔')
        .replace(/\b(NL|Netherlands)\b/g, '荷兰')
        .replace(/\b(NZ|New Zealand)\b/g, '新西兰')
        .replace(/\b(NI|Nicaragua)\b/g, '尼加拉瓜')
        .replace(/\b(NE|Niger)\b/g, '尼日尔')
        .replace(/\b(NG|Nigeria)\b/g, '尼日利亚')
        .replace(/\b(NK|North Korea)\b/g, '朝鲜')
        .replace(/\b(NO|Norway)\b/g, '挪威')
        .replace(/\b(OM|Oman)\b/g, '阿曼')
        .replace(/\b(PK|Pakistan)\b/g, '巴基斯坦')
        .replace(/\b(PA|Panama)\b/g, '巴拿马')
        .replace(/\b(PY|Paraguay)\b/g, '巴拉圭')
        .replace(/\b(PE|Peru)\b/g, '秘鲁')
        .replace(/\b(PH|Philippines)\b/g, '菲律宾')
        .replace(/\b(PT|Portugal)\b/g, '葡萄牙')
        .replace(/\b(PR|Puerto Rico)\b/g, '波多黎各')
        .replace(/\b(QA|Qatar)\b/g, '卡塔尔')
        .replace(/\b(RO|Romania)\b/g, '罗马尼亚')
        .replace(/\b(RU|Russia)\b/g, '俄罗斯')
        .replace(/\b(RW|Rwanda)\b/g, '卢旺达')
        .replace(/\b(SM|San Marino)\b/g, '圣马力诺')
        .replace(/\b(SA|Saudi Arabia)\b/g, '沙特阿拉伯')
        .replace(/\b(SN|Senegal)\b/g, '塞内加尔')
        .replace(/\b(RS|Serbia)\b/g, '塞尔维亚')
        .replace(/\b(SL|Sierra Leone)\b/g, '塞拉利昂')
        .replace(/\b(SK|Slovakia)\b/g, '斯洛伐克')
        .replace(/\b(SI|Slovenia)\b/g, '斯洛文尼亚')
        .replace(/\b(SO|Somalia)\b/g, '索马里')
        .replace(/\b(ZA|South Africa)\b/g, '南非')
        .replace(/\b(ES|Spain)\b/g, '西班牙')
        .replace(/\b(LK|Sri Lanka)\b/g, '斯里兰卡')
        .replace(/\b(SD|Sudan)\b/g, '苏丹')
        .replace(/\b(SR|Suriname)\b/g, '苏里南')
        .replace(/\b(SZ|Swaziland|Eswatini)\b/g, '斯威士兰')
        .replace(/\b(SE|Sweden)\b/g, '瑞典')
        .replace(/\b(CH|Switzerland)\b/g, '瑞士')
        .replace(/\b(SY|Syria)\b/g, '叙利亚')
        .replace(/\b(TJ|Tajikistan)\b/g, '塔吉克斯坦')
        .replace(/\b(TZ|Tanzania)\b/g, '坦桑尼亚')
        .replace(/\b(TH|Thailand)\b/g, '泰国')
        .replace(/\b(TG|Togo)\b/g, '多哥')
        .replace(/\b(TO|Tonga)\b/g, '汤加')
        .replace(/\b(TT|Trinidad and Tobago)\b/g, '特立尼达和多巴哥')
        .replace(/\b(TN|Tunisia)\b/g, '突尼斯')
        .replace(/\b(TR|Turkey)\b/g, '土耳其')
        .replace(/\b(TM|Turkmenistan)\b/g, '土库曼斯坦')
        .replace(/\b(VI|U.S. Virgin Islands)\b/g, '美属维尔京群岛')
        .replace(/\b(UG|Uganda)\b/g, '乌干达')
        .replace(/\b(UA|Ukraine)\b/g, '乌克兰')
        .replace(/\b(UY|Uruguay)\b/g, '乌拉圭')
        .replace(/\b(UZ|Uzbekistan)\b/g, '乌兹别克斯坦')
        .replace(/\b(VE|Venezuela)\b/g, '委内瑞拉')
        .replace(/\b(VN|Vietnam)\b/g, '越南')
        .replace(/\b(YE|Yemen)\b/g, '也门')
        .replace(/\b(ZM|Zambia)\b/g, '赞比亚')
        .replace(/\b(ZW|Zimbabwe)\b/g, '津巴布韦')
        .replace(/\b(AD|Andorra)\b/g, '安道尔')
        .replace(/\b(RE|Reunion)\b/g, '留尼汪')
        .replace(/\b(PL|Poland)\b/g, '波兰')
        .replace(/\b(GU|Guam)\b/g, '关岛')
        .replace(/\b(VA|Vatican)\b/g, '梵蒂冈')
        .replace(/\b(LI|Liechtenstein)\b/g, '列支敦士登')
        .replace(/\b(CW|Curacao)\b/g, '库拉索')
        .replace(/\b(SC|Seychelles)\b/g, '塞舌尔')
        .replace(/\b(AQ|Antarctica)\b/g, '南极')
        .replace(/\b(GI|Gibraltar)\b/g, '直布罗陀')
        .replace(/\b(CU|Cuba)\b/g, '古巴')
        .replace(/\b(FO|Faroe Islands)\b/g, '法罗群岛')
        .replace(/\b(AX|Aland Islands)\b/g, '奥兰群岛')
        .replace(/\b(BM|Bermuda)\b/g, '百慕达')
        .replace(/\b(TL|East Timor|Timor-Leste)\b/g, '东帝汶')

      // 将 [任意文本] 1x 转换为 [相同文本] 2x
        proxy.name = proxy.name.replace(/\[([^\]]+)\]\s*1x/gi, '[$1] 2x');
        proxy.name = proxy.name.replace(/(香港|新加坡|美国|日本|台湾)\s*实验性\s*1\b/g, '$1 实验性');
        proxy.name = proxy.name.replace(/(香港|新加坡|美国|日本|台湾)\s*(高级|标准)\s*(\d+)\b/g, '$1 $2 $3');
        proxy.name = proxy.name.replace(/([^\s])HOME\b/g, '$1 HOME');

      // 过滤不符合指定内容的代理名称
      const filterPattern = /(?:\W|^)(订阅|套餐|到期|有效|剩余|版本|已用|过期|失联|测试|官方|网址|备用|群|TEST|客服|网站|获取|流量|机场|下次|官址|联系|邮箱|工单|学术|USE|USED|TOTAL|EXPIRE|EMAIL|Traffic)(?:\W|$)/i;
      if (filterPattern.test(proxy.name)) return null; // 过滤匹配的代理

      return proxy;
    })
    .filter(proxy => proxy !== null) // 去除已过滤的代理
    .sort((a, b) => {
      // 排序操作，根据提供的排序规则优先级排序
      const sortPatterns = [
        /活动/i,                                      // 优先匹配 "活动"
        /直连/i,                                      // 优先匹配 "直连"
        /\|\s*0\.\s*[23]X/i,                         // 匹配 | 0.2X 或 | 0.3X
        /实验性/i,                                    // 实验性匹配模式
        /Game|游戏/i,                                    // 游戏节点匹配模式
        /香港|HK|Hong Kong|港/i,                       // 香港匹配模式
        /台湾|TW|Taiwan|台/i,                          // 台湾匹配模式
        /日本|JP|Tokyo|Osaka|Japan|日(?!利亚)/i,      // 日本匹配模式，排除 "日利亚" (尼日利亚)
        /新加坡|SG|Singapore|新(?!西兰)/i,            // 新加坡匹配模式，排除 "新西兰"
        /美国|US|United States|LA|Los Angeles|New York|San Francisco|美/i,  // 美国匹配模式
        /韩国|KR|South Korea|首尔/i,                  // 韩国匹配模式
        /马来西亚|MY|Malaysia|大马/i,                // 马来西亚匹配模式
        /英国|UK|United Kingdom|伦敦/i,               // 英国匹配模式
        /德国|DE|Germany|柏林/i,                      // 德国匹配模式
        /法国|FR|France|巴黎/i                        // 法国匹配模式
      ];
      
      // 按照规则优先级进行排序
      for (let pattern of sortPatterns) {
        const aMatch = pattern.test(a.name);
        const bMatch = pattern.test(b.name);
        if (aMatch && !bMatch) return -1; // a 优先
        if (!aMatch && bMatch) return 1;  // b 优先
      }
      return 0; // 如果都未匹配任何模式或都匹配，保留原顺序
    });
}
 
