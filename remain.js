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
        .replace(/\[Promotion.*?\]\s*x\s*(\d\.\d+)/i, '| $1x')      // 处理促销标记格式
        .replace(/(\d+\.\d)0+x/g, '$1x')                            // 删除倍率小数末尾的0
        .replace(/\[(\d+(\.\d+)?[Xx])\]/g, '| $1')                 // 统一倍率标记格式：[数字X] -> | 数字x
        .replace(/\[(Aliyun|UDPN)\s*(\d+[Xx])\]/g, '| $2')         // 处理供应商倍率格式
        .replace(/([^\s\d.])(\d)/g, '$1 $2')                        // 数字前添加空格分隔（排除小数点）
        .replace(/(?<!\S)\[Wcloud\](?!\S)/g, '| 2x')               // Wcloud特殊处理
        .replace(/\s{2,}/g, ' ')                                   // 合并多余空格
        .replace(/X/g, 'x')                                        // 统一倍率标记为小写
        .trim();                                                   // 去除首尾空格
        
      // 3. 删除冗余信息
      proxy.name = proxy.name
        // 3.1 删除供应商标记
        .replace(/\b(Nerocloud|UDPN|HUAWEI|DMIT|Eons|Gcore|Jinx|Nearoute|Cloudflare|Misaka|Sakura|DigitalOcean|AWS|SG\.GS|Akile|Akari|PQS|Apol|Bangmod|Oracle|Linode|Gbnetwork|Webconex|Eastern|Aliyun|Google Cloud|Microsoft Azure|Vultr|OVH|Hetzner|Tencent Cloud|IDCloudhost|UpCloud|Scaleway|Rackspace|HostGator|GoDaddy|DreamHost|Fastly|Bluehost|InMotion|Kinsta|Namecheap|Hostinger)\b/gi, '')
        // 3.2 删除通用标记
        .replace(/家宽|IEPL|中继|Base|Plus|限速|5M/gi, '')
        // 3.3 删除特殊标记
        .replace(/\(HW\)/gi, '')
        // 3.4 删除特殊字符串
        .replace(/(乙酰氨基酚|次硝酸甘油|甲基苯丙酮|双氯芬酸钠|澳士蛋白酶|羟苯磺酸钠|氨基酮戊酸|盐酸氨溴索|磷酸肌酸钠|盐酸可待因|磺胺甲恶唑|尼达莫德酮)/g, '');

      // 4. 运营商标准化处理
      proxy.name = proxy.name
        // 4.1 运营商重命名为 HOME
        .replace(/\b(i-Cable|Comcast|Maxis|Sejong|NTT|CTM|HGC|Rakuten|HKT|HKBN|HiNet|Seednet|M1|CAT|Exetel|Biglobe|KDDI|SoNet|SoftBank|TM|KT|SK|LG)\b/gi, 'HOME')
        .replace(/\b(Frontier|Verizon|AT&T|ATT|T-Mobile|Videotron|SFR|Vodafone|Virgin|BT)\b/gi, 'HOME')
        // ... (保持原有的运营商替换规则)

      // 5. 区域名称标准化
      proxy.name = proxy.name
        // 5.1 特殊区域名称处理
        .replace(/狮城/g, '新加坡')                                          
        .replace(/\[home\]/gi, '丨HOME 2x')
        
        // 5.2 运营商标记清理（添加新规则）
        .replace(/\s*丨.*?(移动|联通|电信|双线|三线)(?=[^\u4e00-\u9fa5]|$)/g, '')  // 移除运营商标记
        
        // 5.3 主要区标准化
        .replace(/\b(HK|Hong Kong)\b/g, '香港')
        .replace(/\b(MO|Macao|Macau)\b/g, '澳门')
        .replace(/\b(TW|Taiwan)\b/g, '台湾')
        .replace(/\b(JP|Japan)\b/g, '日本')
        .replace(/\b(KR|South Korea|Korea)\b/g, '韩国')
        .replace(/\b(SG|Singapore)\b/g, '新加坡')
        .replace(/\b(US|USA|United States|America)\b/g, '美国')
        .replace(/\b(UK|GB|United Kingdom|Britain|England)\b/g, '英国')
        
        // 5.4 欧洲地区标准化
        .replace(/\b(FR|France)\b/g, '法国')
        .replace(/\b(DE|Germany)\b/g, '德国')
        .replace(/\b(IT|Italy|Italia|Milano|Rome|Turin|Florence)\b/g, '���大利')  // 更新：添加Italia和更多城市
        .replace(/\b(ES|Spain|Madrid)\b/g, '西班牙')        // 添加马德里
        .replace(/\b(PT|Portugal|Lisbon)\b/g, '葡萄牙')     // 添加里斯本
        .replace(/\b(NL|Netherlands|Amsterdam)\b/g, '荷兰')  // 添加阿姆斯特丹
        .replace(/\b(BE|Belgium|Brussels)\b/g, '比利时')    // 添加布鲁塞尔
        .replace(/\b(SE|Sweden|Stockholm)\b/g, '瑞典')      // 添加斯德哥尔摩
        .replace(/\b(NO|Norway|Oslo)\b/g, '挪威')          // 添加奥斯陆
        .replace(/\b(FI|Finland|Helsinki)\b/g, '芬兰')     // 添加赫尔辛基
        .replace(/\b(DK|Denmark|Copenhagen)\b/g, '丹麦')    // 添加哥本哈根
        .replace(/\b(IE|Ireland|Dublin)\b/g, '爱尔兰')     // 添加都柏林
        
        // 5.5 亚洲地区标准化
        .replace(/\b(AU|Australia|Sydney|Melbourne)\b/g, '澳大利亚')  // 添加悉尼和墨尔本
        .replace(/\b(NZ|New Zealand|Auckland)\b/g, '新西兰')         // 添加奥克兰
        .replace(/\b(ID|Indonesia|Jakarta)\b/g, '印尼')             // 添加雅加达
        .replace(/\b(MY|Malaysia|Kuala Lumpur)\b/g, '马来西亚')      // 添加吉隆坡
        .replace(/\b(TH|Thailand|Bangkok)\b/g, '泰国')              // 添加曼谷
        .replace(/\b(VN|Vietnam|Hanoi|Ho Chi Minh)\b/g, '越南')     // 添加河内和胡志明
        .replace(/\b(PH|Philippines|Manila)\b/g, '菲律宾')          // 添加马尼拉
        .replace(/\b(IN|India|Mumbai|Delhi)\b/g, '印度')           // 添加孟买和德里
        
        // 5.6 中东地区标准化
        .replace(/\b(AE|UAE|United Arab Emirates|Dubai)\b/g, '阿联酋')  // 添加迪拜
        .replace(/\b(IL|Israel|Tel Aviv)\b/g, '以色列')                // 添加特拉维夫
        .replace(/\b(TR|Turkey|Türkiye|Istanbul|Ankara)\b/g, '土耳其')         // 添加伊斯坦布尔和安卡拉
        .replace(/\b(SA|Saudi Arabia|Riyadh)\b/g, '沙特')             // 添加利雅得
        
        // 5.7 美洲地区标准化
        .replace(/\b(CA|Canada|Toronto|Vancouver)\b/g, '加拿大')        // 添加多伦多和温哥华
        .replace(/\b(BR|Brazil|Sao Paulo)\b/g, '巴西')                // 添加圣保罗
        .replace(/\b(MX|Mexico|Mexico City)\b/g, '墨西哥')            // 添加墨西哥城
        .replace(/\b(AR|Argentina|Buenos Aires)\b/g, '阿根廷')         // 添加布宜诺斯艾利斯
        
        // 5.8 其他地区标准化
        .replace(/\b(RU|Russia|Moscow)\b/g, '俄罗斯')                  // 添加莫斯科
        .replace(/\b(ZA|South Africa|Johannesburg)\b/g, '南非')        // 添加约翰内斯堡
        .replace(/\b(EG|Egypt|Cairo)\b/g, '埃及')                     // 添加开罗
        // 新增国家名称转换
        .replace(/\b(Bangladesh|Dhaka)\b/g, '孟加拉')
        .replace(/\b(Switzerland|Zurich|Geneva)\b/g, '瑞士')
        .replace(/\b(Austria|Vienna)\b/g, '奥地利')
        .replace(/\b(Iceland|Reykjavik)\b/g, '冰岛')
        .replace(/\b(Poland|Warsaw)\b/g, '波兰')
        .replace(/\b(Angola|Luanda)\b/g, '安哥拉')
        .replace(/\b(Ukraine|Kiev)\b/g, '乌克兰')
        .replace(/\b(Cambodia|Phnom Penh)\b/g, '柬埔寨')
        .replace(/\b(Nepal|Kathmandu)\b/g, '尼泊尔')
        .replace(/\b(Chile|Santiago)\b/g, '智利')
        .replace(/\b(Colombia|Bogota)\b/g, '哥伦比亚')
        .replace(/\b(Peru|Lima)\b/g, '秘鲁')
        .replace(/\b(Bolivia|La Paz)\b/g, '玻利维亚')
        .replace(/\b(Luxembourg|Luxembourg City)\b/g, '卢森堡')
        .replace(/\b(Estonia|Tallinn)\b/g, '爱沙尼亚')
        .replace(/\b(Hungary|Budapest)\b/g, '匈牙利')
        .replace(/\b(Moldova|Chisinau)\b/g, '摩尔多瓦')
        .replace(/\b(Romania|Bucharest)\b/g, '罗马尼亚')
        .replace(/\b(Bulgaria|Sofia)\b/g, '保加利亚')
        .replace(/\b(Serbia|Belgrade)\b/g, '塞尔维亚')
        .replace(/\b(Greece|Athens)\b/g, '希腊')
        .replace(/\b(Iraq|Baghdad)\b/g, '伊拉克')
        .replace(/\b(Togo|Lome)\b/g, '多哥')
        .replace(/\b(Tunisia|Tunis)\b/g, '突尼斯')
        .replace(/\b(Pakistan|Islamabad|Karachi)\b/g, '巴基斯坦')
        .replace(/\b(Kazakhstan|Astana)\b/g, '哈萨克斯坦')
        .replace(/\b(Nigeria|Lagos|Abuja)\b/g, '尼日利亚')
        .replace(/\b(Antarctica)\b/g, '南极洲')
        // 添加更多洲国家
        .replace(/\b(Croatia|Zagreb)\b/g, '克罗地亚')
        .replace(/\b(Czech Republic|Czech|Czechia|Prague|Brno|Ostrava)\b/g, '捷克')  // 更新：添加Czechia和更多城市
        .replace(/\b(Slovakia|Bratislava)\b/g, '斯洛伐克')
        .replace(/\b(Slovenia|Ljubljana)\b/g, '斯洛文尼亚')
        .replace(/\b(Latvia|Riga)\b/g, '拉脱维亚')
        .replace(/\b(Lithuania|Vilnius)\b/g, '立陶宛')
        .replace(/\b(Belarus|Minsk)\b/g, '白俄罗斯')
        .replace(/\b(Malta|Valletta)\b/g, '马耳他')
        .replace(/\b(Cyprus|Nicosia)\b/g, '塞浦路斯')
        
        // 添加更多亚洲国家
        .replace(/\b(Laos|Vientiane)\b/g, '老挝')
        .replace(/\b(Myanmar|Yangon|Burma)\b/g, '缅甸')
        .replace(/\b(Brunei|Bandar Seri Begawan)\b/g, '文莱')
        .replace(/\b(Mongolia|Ulaanbaatar)\b/g, '蒙古')
        .replace(/\b(Bhutan|Thimphu)\b/g, '不丹')
        .replace(/\b(Sri Lanka|Colombo)\b/g, '斯里兰卡')
        .replace(/\b(Maldives|Male)\b/g, '马尔代夫')
        
        // 添加更多中东国家
        .replace(/\b(Kuwait|Kuwait City)\b/g, '科威特')
        .replace(/\b(Bahrain|Manama)\b/g, '巴林')
        .replace(/\b(Qatar|Doha)\b/g, '卡塔尔')
        .replace(/\b(Oman|Muscat)\b/g, '阿曼')
        .replace(/\b(Yemen|Sanaa)\b/g, '也门')
        .replace(/\b(Jordan|Amman)\b/g, '约旦')
        .replace(/\b(Lebanon|Beirut)\b/g, '黎巴嫩')
        
        // 添加更多非洲国家
        .replace(/\b(Morocco|Rabat)\b/g, '摩洛哥')
        .replace(/\b(Algeria|Algiers)\b/g, '阿尔及利亚')
        .replace(/\b(Libya|Tripoli)\b/g, '利比亚')
        .replace(/\b(Sudan|Khartoum)\b/g, '苏丹')
        .replace(/\b(Ethiopia|Addis Ababa)\b/g, '埃塞俄比亚')
        .replace(/\b(Kenya|Nairobi)\b/g, '肯尼亚')
        .replace(/\b(Tanzania|Dodoma)\b/g, '坦桑尼亚')
        .replace(/\b(Uganda|Kampala)\b/g, '乌干达')
        .replace(/\b(Ghana|Accra)\b/g, '加纳')
        
        // 添加更多美洲国家
        .replace(/\b(Venezuela|Caracas)\b/g, '委内瑞拉')
        .replace(/\b(Ecuador|Quito)\b/g, '厄瓜多尔')
        .replace(/\b(Paraguay|Asuncion)\b/g, '巴拉圭')
        .replace(/\b(Uruguay|Montevideo)\b/g, '乌拉圭')
        .replace(/\b(Panama|Panama City)\b/g, '巴拿马')
        .replace(/\b(Costa Rica|San Jose)\b/g, '哥斯达黎加')
        .replace(/\b(Jamaica|Kingston)\b/g, '牙买加');

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
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
      }
      return 0;
    });
}

// 排序优先级定义
const sortPatterns = [
  // 1. 特殊类型节点优先级
  /活动/i,                                      // 1.1 活动节点最优先
  /直连/i,                                      // 1.2 直连节点次优先
  /Game|游戏/i,                                 // 1.3 游戏节点
  
  // 2. 倍率相关优先级
  /\|\s*0\.\s*[123456789]X/i,                  // 2.1 低倍率通用匹配
  /低倍率/i,                                    // 2.2 低倍率标记
  /0\.\d+\s*[xX]/i,                           // 2.3 小数倍率
  /实验性/i,                                    // 2.4 实验性节点
  
  // 3. 主要地区优先级
  /香港|HK|Hong Kong|港/i,                      // 3.1 香港节点
  /台湾|TW|Taiwan|台/i,                         // 3.2 台湾节点
  /日本|JP|Tokyo|Osaka|Japan|日(?!利亚)/i,      // 3.3 日本节点
  /新加坡|SG|Singapore|新(?!西兰)/i,            // 3.4 新加坡节点
  /美国|US|United States|LA|Los Angeles|New York|San Francisco|美/i,  // 3.5 美国节点
  
  // 4. 次要地区优先级
  /韩国|KR|South Korea|首尔/i,                  // 4.1 韩国节点
  /马来西亚|MY|Malaysia|大马/i,                 // 4.2 马来西亚节点
  /英国|UK|United Kingdom|伦敦/i,               // 4.3 英国节点
  /德国|DE|Germany|柏林/i,                      // 4.4 德国节点
  /法国|FR|France|巴黎/i,                       // 4.5 法国节点
  
  // 5. 具体倍率优先级（从低到高）
  /\|\s*0\.1x/i,                               // 5.1 0.1倍率节点
  /\|\s*0\.2x/i,                               // 5.2 0.2倍率节点
  /\|\s*0\.3x/i,                               // 5.3 0.3倍率节点
  /\|\s*0\.4x/i,                               // 5.4 0.4倍率节点
  /\|\s*0\.5x/i,                               // 5.5 0.5倍率节点
  /\|\s*0\.6x/i,                               // 5.6 0.6倍率节点
  /\|\s*0\.7x/i,                               // 5.7 0.7倍率节点
  /\|\s*0\.8x/i,                               // 5.8 0.8倍率节点
  /\|\s*0\.9x/i                                // 5.9 0.9倍率节点
];
  
