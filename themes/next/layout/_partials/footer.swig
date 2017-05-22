<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

{% if theme.copyright %}


<div class="busuanzi-count">
  <script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script> 
    <span class="site-uv">
      <i class="fa fa-user"></i> 到访数:
      <span class="busuanzi-value" id="busuanzi_value_site_uv"></span>
    </span>  
    <span class="site-pv">
      <i class="fa fa-eye"></i> 访问量:
      <span class="busuanzi-value" id="busuanzi_value_site_pv"></span>
    </span>
</div>

{% endif %}
<script type="text/javascript">
   var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1261969478'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s19.cnzz.com/z_stat.php%3Fid%3D1261969478%26show%3Dpic' type='text/javascript'%3E%3C/script%3E"));
</script>
<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js">
</script>
