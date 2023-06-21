#!/usr/bin/bash
echo Press Ctrl-C if you have not run cleanRust.sh
echo or you have not run mkList.sh rs
echo Otherwise press enter
read line

# Loop through list of Rust source files
masterList=rs_masterList.txt

# REPLACE:
SERVICE_FROM=Config\,
FROM_REGDEC=region::ChainProvider::first_try\(region.map\(Region::new\)\)
FROM_CONF=Config::builder\(\).region\(region\).build\(\)
FROM_CLIENT=Client::from_conf\(conf\)
FROM_REGION=region.region\(\).unwrap\(\).as_ref\(\)

SERVICE_TO=""
TO_REGDEC=RegionProviderChain::default_provider\(\).or_else\(Region::new\(\"us-west-2\"\)\)\;
TO_CONF=aws_config::from_env\(\).region\(region\).load\(\).await;
TO_CLIENT=Client::new\(\&conf\)
TO_REGION=region.region\(\).await.unwrap\(\).as_ref\(\)

echo Changing:
echo $FROM_REGDEC
echo To:
echo $TO_REGDEC

cat $masterList |
while read line
do
    sed -i 's/'${SERVICE_FROM}'/''/g' $line
    sed -i 's/'${FROM_REGDEC}'/'${TO_REGDEC}'/g' $line
    sed -i 's/'${FROM_CONF}'/'${TO_CONF}'/g' $line
    sed -i 's/'${FROM_REGION}'/'${TO_REGION}'/g' $line
    # Delete reference to ProvideRegion, default_provider, etc.
    sed -i /ProvideRegion/d $line
    sed -i /use\ aws_types::region/d $line
    sed -i /or_default_provider/d $line
    sed -i /or_else\(Region::new/d $line

    found=`git diff "$line" 2> /dev/null`

    if [ "$found" != "" ]    
        then
            echo ""
            echo "Updated $line"
        else
            echo -n "."
        fi
done

echo "Do not forget to add to package declarations:"
echo "use aws_config::meta::region::RegionProviderChain;"
echo "And add to Cargo.toml:"
echo "aws-config = { path = "../../build/aws-sdk/aws-config" }"

echo
echo Done
echo
