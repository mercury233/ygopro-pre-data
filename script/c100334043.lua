--トークバック・ランサー
--Talkback Lancer
--Script by mercury233
function c100334043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100334043.matfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100334043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100334043)
	e1:SetCost(c100334043.spcost)
	e1:SetTarget(c100334043.sptg)
	e1:SetOperation(c100334043.spop)
	c:RegisterEffect(e1)
end
function c100334043.matfilter(c)
	return c:IsLevelBelow(2) and c:IsLinkRace(RACE_CYBERSE)
end
function c100334043.cfilter(c,e,tp,zone)
	return c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingTarget(c100334043.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalCode())
end
function c100334043.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100334043.cfilter,1,c,e,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c100334043.cfilter,1,1,c,e,tp,zone)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c100334043.spfilter(c,e,tp,code)
	return c:IsSetCard(0x101) and c:GetOriginalCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100334043.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc~=cc and c100334043.spfilter(chkc,e,tp,cc:GetOriginalCode()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100334043.spfilter,tp,LOCATION_GRAVE,0,1,1,cc,e,tp,cc:GetOriginalCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100334043.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
