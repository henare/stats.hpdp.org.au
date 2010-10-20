
var W3C = (document.getElementById) ? 1 : 0;
var IE4 = (document.all && !W3C) ? 1 : 0;
var doc=W3C?document.getElementsByTagName('*'):(IE4?document.all:false)
var currentIndx="-"
function next(c){
	r=fld("round"+c).value
	p=2-fld("game"+c).value%2
	g=Math.round(fld("game"+c).value/2)
	return 62-Math.pow(2,6-r)+2*g+p
}
function prev(c){
	r=fld("round"+c).value
	if(r==1) return 0
	g=fld("game"+c).value*2- (fld("player"+c).value%2)
	c2=64-Math.pow(2,8-r)+2*g
	nm=fld("name"+c)
	nm2=fld("name"+c2)
	if(nm2.options[nm2.selectedIndex].text!=nm.options[nm.selectedIndex].text)
		c2--
	return c2
}
function fld(txt){
	return eval("document.forms[0]."+txt)
}
function newPlayer(c){
	if(!(newPl=prompt("Enter new player's name:",""))||newPl==""||newPl.indexOf("'")!=-1){
		return false
	}
	flag=false
	newPl=newPl.toUpperCase()
	for(i=0;i<=playerList.length;i++)
		if(playerList[i]==newPl){
			fld("name"+c).selectedIndex=i
			return 2
		}
	playerList.push(newPl)
	for(i=1;i<=32;i++){
		fld("name"+i).options[fld("name"+i).options.length-1].text = newPl
		fld("name"+i).options[fld("name"+i).options.length] = new Option("-new player-")
	}
	for(i=33;i<=48;i++){
		if(fld("name"+i).options.length!=3 || playerList.length<4){
			fld("name"+i).options[fld("name"+i).options.length-1].text = newPl
			fld("name"+i).options[fld("name"+i).options.length] = new Option("-new player-")
		}
	}
	return 1
}
function setPlayers(c){
	if(fld("round"+c).value==6) return
	if(fld("name"+c).options[fld("name"+c).selectedIndex].text=="-new player-")
		if(newP=!newPlayer(c))
			fld("name"+c).selectedIndex=currentIndx
		else if(newP==2){
			setBuyBack(fld("name"+c).selectedIndex)
			return
		}
	if(fld("round"+c).value==1){
		setBuyBack(fld("name"+c).selectedIndex)
		currentIndx=fld("name"+c).selectedIndex
	}
	player=fld("player"+c).value
	otherPlayer = c+(1.5-player)*2
	if(fld("round"+c).value==1){
		fld("name"+next(c)).options.length=3
//		fld("name"+next(c)).selectedIndex = fld("name"+c).selectedIndex
	}else if(fld("round"+c).value==2 && fld("name"+c).length>3){
		if(fld("name"+prev(c)).selectedIndex==0 || fld("name"+(prev(c)+1)).selectedIndex==0){
			fld("name"+prev(c)).selectedIndex = fld("name"+c).selectedIndex
			setBuyBack(fld("name"+c).selectedIndex)
		}
	}
	fld("name"+next(c)).options[player].text = fld("name"+c).options[fld("name"+c).selectedIndex].text
	fld("name"+next(c)).options[3-player].text = fld("name"+otherPlayer).options[fld("name"+otherPlayer).selectedIndex].text
	setPlayers(next(c))
}
function setBuyBack(indx){
	flag1=false; flag2=false;
	for(i=1;i<=32;i++) {
		j=fld("name"+i).selectedIndex
		if(j==indx||j==currentIndx){
			if(doc)	fld("bb"+i).checked=false
			fld("buyback"+i).value=0
		}
	}
	for(i=1;i<=32;i++) {
		if((j=fld("name"+i).selectedIndex)==0)
			continue
		if(j==indx){
			if(flag1){
				if(doc)	fld("bb"+i).checked=true
				fld("buyback"+i).value=1
			}
			flag1=true
		}
		if(j==currentIndx){
			if(flag2){
				if(doc)	fld("bb"+i).checked=true
				fld("buyback"+i).value=1
			}
			flag2=true
		}
	}
}
function prepForm(form){
	for(i=1;i<=63;i++){
		if(i>32){
			fld("buyback"+i).value=fld("buyback"+prev(i)).value
			fld("path"+i).value=fld("path"+prev(i)).value
		}
		if(i<63 && i==prev(next(i)) && fld("name"+next(i)).options[fld("name"+next(i)).selectedIndex].text==fld("name"+i).options[fld("name"+i).selectedIndex].text)
			 fld("result"+i).value=1
		else fld("result"+i).value=0
	}
}
function setScoring(box){
	for(i=0;i<box.form.elements.length && box.form.elements[i]!=box;i++){}
	for(j=i+1;j<=i+8;j++)
		box.form.elements[j].disabled=!box.checked
}
