--マイクロ・コーダー
--Micro Coder
--Script by nekrozar
function c100334004.initial_effect(c)
	--temp
	if EFFECT_EXTRA_LINK_MATERIAL==nil then
		EFFECT_EXTRA_LINK_MATERIAL=358

function Auxiliary.LExtraFilter(c,f,lc)
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	return c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL) and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function Auxiliary.LCheckOtherMaterial(c,sg,lc)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and not f(te,lc,sg) then return false end
	end
	return true
end
function Auxiliary.LCheckMaterialCompatibility(sg,lc)
	for tc in Auxiliary.Next(sg) do
		local mg=sg:Filter(aux.TRUE,tc)
		local res=Auxiliary.LCheckOtherMaterial(tc,mg,lc)
		mg:DeleteGroup()
		if not res then return false end
	end
	return true
end
function Auxiliary.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.LCheckMaterialCompatibility(sg,lc)
		and (Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
			or ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LCheckGoal(tp,sg,lc,minc,ct,gf)
	return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
end
function Auxiliary.LinkCondition(f,minc,maxc,gf)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Auxiliary.GetLinkMaterials(tp,f,c)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				local ct=sg:GetCount()
				if ct>maxc then return false end
				return Auxiliary.LCheckGoal(tp,sg,c,minc,ct,gf)
					or mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf)
			end
end
function Auxiliary.LinkTarget(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Auxiliary.GetLinkMaterials(tp,f,c)
				local bg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if #bg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					bg:Select(tp,#bg,#bg,nil)
				end
				local sg=Group.CreateGroup()
				sg:Merge(bg)
				local finish=false
				while #sg<maxc do
					finish=Auxiliary.LCheckGoal(tp,sg,c,minc,#sg,gf)
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,#sg,minc,maxc,gf)
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if #sg==maxc then finish=true end
						else
							sg:RemoveCard(tc)
						end
					elseif #bg>0 and #sg<=#bg then
						return false
					end
				end
				if finish then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end

	end
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100334004.matcon)
	e1:SetValue(c100334004.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(c100334004.ctcon)
    e2:SetOperation(c100334004.ctop)
    c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100334004,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,100334004)
	e3:SetCondition(c100334004.thcon)
	e3:SetTarget(c100334004.thtg)
	e3:SetOperation(c100334004.thop)
	c:RegisterEffect(e3)
end
function c100334004.matcon(e)
    return Duel.GetFlagEffect(e:GetHandlerPlayer(),100334004)==0
end
function c100334004.mfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function c100334004.matval(e,c,mg)
    return c:IsSetCard(0x101) and mg:IsExists(c100334004.mfilter,1,nil)
end
function c100334004.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c100334004.ctop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,100334004,RESET_PHASE+PHASE_END,0,1)
end
function c100334004.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c100334004.thfilter(c,chk)
	return ((c:IsSetCard(0x218) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (chk==1 and c:IsRace(RACE_CYBERSE) and c:IsLevel(4))) and c:IsAbleToHand()
end
function c100334004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100334004.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100334004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100334004.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
