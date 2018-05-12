--シンデレラ
--Cinderella
--Script by dest
function c100227004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100227004)
	e1:SetTarget(c100227004.target)
	e1:SetOperation(c100227004.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100227004,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c100227004.eqcon)
	e3:SetTarget(c100227004.eqtg)
	e3:SetOperation(c100227004.eqop)
	c:RegisterEffect(e3)
end
c100227004.card_code_list={100227010}
function c100227004.filter(c,e,tp)
	return c:IsCode(100227005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100227004.efilter(c,ec)
	return c:IsCode(100227011) and c:CheckEquipTarget(ec)
end
function c100227004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100227004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100227004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100227004.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsEnvironment(100227010) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100227004.efilter,tp,LOCATION_DECK,0,1,nil,c)
		and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(100227004,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqg=Duel.SelectMatchingCard(tp,c100227004.efilter,tp,LOCATION_DECK,0,1,1,nil,c)
		Duel.Equip(tp,eqg:GetFirst(),c)
	end
end
function c100227004.eqcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c100227004.eqfilter(c,tc,tp)
	return c:IsCode(100227011) and tc:GetEquipGroup():IsContains(c)
		and Duel.IsExistingTarget(c100227004.eqtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc,c)
end
function c100227004.eqtfilter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c100227004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c100227004.eqfilter,tp,LOCATION_SZONE,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectTarget(tp,c100227004.eqfilter,tp,LOCATION_SZONE,0,1,1,nil,c,tp):GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100227004.eqtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,tc)
end
function c100227004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e)
		or sc:IsFacedown() or not sc:IsRelateToEffect(e) then return end
	local ec=e:GetLabelObject()
	if tc==ec then tc=sc end
	Duel.Equip(tp,ec,tc)
end
