--灼熱の火霊使いヒータ
--Hiita the Blazing Fire Charmer
--Script by nekrozar
function c101007056.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c101007056.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007056,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101007056)
	e1:SetTarget(c101007056.sptg)
	e1:SetOperation(c101007056.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007056,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101007156)
	e2:SetCondition(c101007056.thcon)
	e2:SetTarget(c101007056.thtg)
	e2:SetOperation(c101007056.thop)
	c:RegisterEffect(e2)
end
function c101007056.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c101007056.spfilter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101007056.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101007056.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101007056.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101007056.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101007056.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c101007056.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c101007056.thfilter(c)
	return c:IsDefenseBelow(1500) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c101007056.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101007056.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101007056.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101007056.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
