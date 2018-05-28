--Vendread Nightmare
--Script by dest
function c101004085.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--increase lv
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101004085.lvcost)
	e2:SetTarget(c101004085.lvtg)
	e2:SetOperation(c101004085.lvop)
	c:RegisterEffect(e2)
	--increase atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101004085)
	e3:SetCondition(c101004085.atkcon)
	e3:SetOperation(c101004085.atkop)
	c:RegisterEffect(e3)
end
function c101004085.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101004085.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x106)
end
function c101004085.filter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and Duel.CheckReleaseGroup(tp,c101004085.cfilter,1,c,c)
end
function c101004085.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101004085.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingTarget(c101004085.filter,tp,LOCATION_MZONE,0,1,nil,tp)
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c101004085.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local sg=Duel.SelectReleaseGroup(tp,c101004085.cfilter,1,1,tc,tc)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function c101004085.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101004085.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc==Duel.GetAttacker() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsFaceup()
		and bit.band(rc:GetType(),0x81)==0x81 and rc:IsSetCard(0x106) and rc:IsControler(tp)
end
function c101004085.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
