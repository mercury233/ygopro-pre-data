--守護竜ピスティ

--Script by nekrozar
function c101007052.initial_effect(c)
	c:SetSPSummonOnce(101007052)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101007052.matfilter,1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101007052.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007052,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101007052)
	e2:SetTarget(c101007052.sptg)
	e2:SetOperation(c101007052.spop)
	c:RegisterEffect(e2)
	if aux.GetMultiLinkedZone==nil then
		function aux.GetMultiLinkedZone(tp)
			local lg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
			local multi_linked_zone=0
			local single_linked_zone=0
			for tc in aux.Next(lg) do
				local zone=tc:GetLinkedZone(tp)&0x7f
				multi_linked_zone=single_linked_zone&zone|multi_linked_zone
				single_linked_zone=single_linked_zone~zone
			end
			return multi_linked_zone
		end
	end
end
function c101007052.matfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_DRAGON)
end
function c101007052.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_DRAGON)
end
function c101007052.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101007052.spfilter(c,e,tp,zone)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101007052.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=aux.GetMultiLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c101007052.spfilter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101007052.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101007052.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101007052.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=aux.GetMultiLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if zone~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
